/*
 * declarator_unit.d
 *
 */

module syntax.declarator_unit;

import syntax.basic_type_suffix_unit;

import ast.declarator_node;

import lex.token;
import lex.lexer;
import logger;

import tango.io.Stdout;

/*

	Declarator => ( BasicTypeSuffix )* ( Declarator ) ( DeclaratorSuffix )*
	            | ( BasicTypeSuffix )* Identifier ( DeclaratorSuffix )*

	(must start with one of these: {* [ ( delegate function})
	DeclaratorMiddle => ( BasicTypeSuffix )* ( ( DeclaratorMiddle ) )? ( DeclaratorSuffix )*

	DeclaratorSuffix => [ ]
	                  | [ Expression ]
	                  | [ Type ]
	                  | ( ( TemplateParameterList )? ( ParameterList

	BasicTypeSuffix => *
	                 | [ ]
	                 | [ Expression ]
					 | [ Expression .. Expression ]
	                 | [ Type ]
	                 | delegate ( ParameterList
	                 | function ( ParameterList

	Must disambiguate between BasicTypeSuffix and DeclaratorSuffix
	If it is a BasicTypeSuffix, disambiguate between Declarator and
	DeclaratorMiddle by looking for a following Identifier or (
	If it is a ( then it could still be either a Declarator or DeclaratorMiddle
	until it finds an Identifier.

	The only difference is that a Declarator can have an initial value.
	That is, = is only allowed (and ... disallowed) when a Declarator is
	found over a DeclaratorMiddle.

*/

class DeclaratorUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	DeclaratorNode parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

		return new DeclaratorNode();
	}

	bool tokenFound(Token token) {
		switch (_state) {
			case 0:
				switch (token.type) {
					case Token.Type.LeftBracket:
					case Token.Type.Delegate:
					case Token.Type.Function:
					case Token.Type.Mul:
						_lexer.push(token);
						Stdout("BasicTypeSuffixUnit").newline;
						auto basic_type = (new BasicTypeSuffixUnit(_lexer, _logger)).parse;
						break;

					case Token.Type.LeftParen:
						// Recursive Declarator
						auto inner_declarator = (new DeclaratorUnit(_lexer, _logger)).parse;
						_state = 2;
						break;

					case Token.Type.Identifier:
						_state = 3;
						Stdout("Name: ")(token.string).newline;
						break;

					default:
						// Bad
						break;
				}
				break;

			// Found BasicTypeSuffix, Look for either a recursive Declarator
			// Identifier or DeclaratorSuffix
			case 1:
				switch (token.type) {
					case Token.Type.LeftParen:
						// Recursive Declarator
						//auto tree = expand!(DeclaratorUnit)();
						_state = 2;
						break;
					case Token.Type.Identifier:
						_state = 3;
						Stdout("Name: ")(token.string).newline;
						break;
					default:
						// Bad
						break;
				}
				break;

			// After a recursive Declarator, look for the end parenthesis
			case 2:
				switch(token.type) {
					case Token.Type.RightParen:
						_state = 3;
						break;
					case Token.Type.Identifier:
					default:
						// Bad
						break;
				}
				break;

			// Found (Declarator) or Identifier... look for Declarator Suffix (if exists)
			case 3:
				switch(token.type) {
					case Token.Type.LeftBracket:
					case Token.Type.Mul:
					case Token.Type.LeftParen:
						_lexer.push(token);
						//auto tree = expand!(DeclaratorSuffixUnit)();
						break;

					default:
						// Fine.
						_lexer.push(token);
						break;
				}
				return false;
			default:
				break;
		}
		return true;
	}

}
