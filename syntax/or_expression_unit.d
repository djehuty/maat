/*
 * or_expression_unit.d
 *
 */

module syntax.or_expression_unit;

import lex.lexer;
import lex.token;
import logger;

import syntax.xor_expression_unit;

/*

	OrExpr => OrExpr | XorExpr
	        | XorExpr

*/

class OrExpressionUnit {
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
      case Token.Type.Or:
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
				auto tree = (new XorExpressionUnit(_lexer, _logger)).parse;

        _state = 1;
				break;
		}

		return true;
  }
}
