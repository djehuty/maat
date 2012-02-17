/*
 * enum_body_unit.d
 *
 */

module syntax.enum_body_unit;

import syntax.assign_expression_unit;

import lex.lexer;
import lex.token;
import logger;

class EnumBodyUnit {
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
		switch (token.type) {
			// Looking for a new member name
			case Token.Type.Identifier:
				if (_state == 1) {
					// Error: A name next to a name??
				}
				_state = 1;
				break;
			case Token.Type.RightCurly:
				// Done.
				return false;
			case Token.Type.Comma:
				if (_state != 1) {
					// Error: A comma by itself?
				}
				_state = 0;
				break;
			case Token.Type.Assign:
				if (_state != 1) {
					// Error: An equals by itself?
				}

				// Look for an assignment expression.
				auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;

				// Stay in the same state and wait for a comma.
				break;
			default:
				break;
		}
		return true;
	}
}
