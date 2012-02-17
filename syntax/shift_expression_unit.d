/*
 * shift_expression_unit.d
 *
 */

module syntax.shift_expression_unit;

import lex.lexer;
import lex.token;
import logger;

import syntax.add_expression_unit;

/*

	ShiftExpr => ShiftExpr >> AddExpr
	           | ShiftExpr << AddExpr
	           | ShiftExpr >>> AddExpr
	           | AddExpr

*/

class ShiftExpressionUnit {
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
			case Token.Type.ShiftLeft:
			case Token.Type.ShiftRight:
			case Token.Type.ShiftRightSigned:
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
				auto expr = (new AddExpressionUnit(_lexer, _logger)).parse;
				this._state = 1;
				break;
		}
		return false;
	}
}
