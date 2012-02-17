/*
 * declarator_suffix_unit.d
 *
 */

module syntax.declarator_suffix_unit;

import syntax.parameter_list_unit;
import syntax.expression_unit;

import lex.lexer;
import lex.token;
import logger;

/*

	DeclaratorSuffix => [ ]
	                  | [ Expression ]
	                  | [ Type ]
	                  | ( TemplateParameterList )? ( ParameterList

*/

class DeclaratorSuffixUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	char[] parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

		return "";
	}

	bool tokenFound(Token token) {
		switch (_state) {
			case 0:
				// Looking for ( or [
				// Types which have () or [] after them
				switch (token.type) {
					case Token.Type.LeftParen:
						_state = 1;
						break;
					case Token.Type.LeftBracket:
						_state = 2;
						break;
					default:
						break;
				}
				break;

			case 1:
				// We have found a ( so we are searching for
				// a right parenthesis
				switch (token.type) {
					case Token.Type.RightParen:
						// Done
						break;
					default:
						// This is a parameter list
						// XXX:
						_lexer.push(token);
						auto params = (new ParameterListUnit(_lexer, _logger)).parse;
						break;
				}
				return false;

			case 2:
				// We have found a [ so we are searching for
				// a right bracket.
				switch (token.type) {
					case Token.Type.RightBracket:
						// Done
						return false;

					case Token.Type.Dot:
						break;

					case Token.Type.Identifier:
						break;

					default:
						// We should assume it is an expression
						_lexer.push(token);
						auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
						break;
				}
				break;
			default:
				break;
		}
		return true;
	}
}
