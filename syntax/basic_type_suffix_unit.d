/*
 * basictypesuffixunit.d
 *
 */

module syntax.basic_type_suffix_unit;

//import ast.basictypesuffixunit;

import syntax.expression_unit;

import ast.type_node;

import lex.token;
import lex.lexer;

import logger;

class BasicTypeSuffixUnit {
private:
	Lexer  _lexer;
	Logger _logger;

  TypeNode _type;

	int    _state;

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	TypeNode parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

		return _type;
	}

	bool tokenFound(Token token) {
		switch(_state) {
			case 0:
				switch (token.type) {
					case Token.Type.Mul:
						return false;

					case Token.Type.LeftBracket:
						_state = 1;
						break;

					case Token.Type.Delegate:
					case Token.Type.Function:
						_state = 2;
						break;

					default:
						// Error:
						// TODO:
            _logger.println("error");
						break;
				}
				break;

			// Saw [ looking for Expression, Type, or ]
			case 1:
				switch(token.type) {
					case Token.Type.RightBracket:
            _type = new TypeNode(TypeNode.Type.Array, null, null);
						return false;

					default:
						// XXX: Disambiguate between Type and Expression
						_lexer.push(token);
						auto tree = (new ExpressionUnit(_lexer, _logger)).parse;
						_state = 3;
						break;
				}
				break;

			// Saw Delegate/Function ... looking for ( ParameterList
			case 2:
				switch(token.type) {
					case Token.Type.LeftParen:
						//auto tree = expand!(ParameterListUnit)();
						return false;

					default:
						// Bad
						break;
				}
				break;

			// Saw Expression, looking for .. or ]
			case 3:
				switch(token.type) {
					case Token.Type.RightBracket:
						return false;

					case Token.Type.Slice:
						auto tree = (new ExpressionUnit(_lexer, _logger)).parse;
						_state = 4;
						break;
				}
				break;

			// Saw Expression .. Expression, looking for ]
			case 4:
				switch(token.type) {
					case Token.Type.RightBracket:
						return false;
					default:
						// Bad
						break;
				}
		}
		return true;
	}
}
