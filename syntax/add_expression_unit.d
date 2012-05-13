/*
 * add_expression_unit.d
 *
 */

module syntax.add_expression_unit;

import lex.lexer;
import lex.token;
import logger;

import syntax.multiply_expression_unit;

/*

	AddExpr => AddExpr + MulExpr
	         | AddExpr - MulExpr
	         | AddExpr ~ MulExpr
	         | MulExpr

*/

class AddExpressionUnit {
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
		if (token.type == Token.Type.Comment) {
			return false;
		}

		switch (token.type) {
			case Token.Type.Add:
			case Token.Type.Sub:
			case Token.Type.Cat:
				if (_state == 1) {
					_state = 0;
					break;
				}

				// Fall through
				goto default;

			default:
				_lexer.push(token);
				if (_state == 1) {
					// Done.
					return false;
				}
				auto expr = (new MultiplyExpressionUnit(_lexer, _logger)).parse;
				_state = 1;
				break;
		}

		return true;
	}
}
