/*
 * logical_and_expression_unit.d
 *
 */

module syntax.logical_and_expression_unit;

import lex.lexer;
import lex.token;
import logger;

import syntax.or_expression_unit;

/*

   LogicalAndExpr => LogicalAndExpr && OrExpr
                   | OrExpr

*/

class LogicalAndExpressionUnit {
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
			case Token.Type.LogicalAnd:
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
				auto tree = (new OrExpressionUnit(_lexer, _logger)).parse;

        _state = 1;
				break;
		}

		return true;
	}
}
