/*
 * multiply_expression_unit.d
 *
 */

module syntax.multiply_expression_unit;

import lex.lexer;
import lex.token;
import logger;

import syntax.unary_expression_unit;

/*

	MulExpr => MulExpr * UnaryExpr
	         | MulExpr / UnaryExpr
	         | MulExpr % UnaryExpr
	         | UnaryExpr

*/

class MultiplyExpressionUnit {
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
			case Token.Type.Mul:
			case Token.Type.Div:
			case Token.Type.Mod:
				if (this._state == 1) {
					this._state = 0;
					break;
				}

				// Fall through
				goto default;

			default:
				_lexer.push(token);
				if (this._state == 1) {
					// Done.
					return false;
				}
				auto expr = (new UnaryExpressionUnit(_lexer, _logger)).parse;
				this._state = 1;
				break;
		}

		return true;
	}
}
