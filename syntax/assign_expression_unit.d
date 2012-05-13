/*
 * assign_expression_unit.d
 *
 */

module syntax.assign_expression_unit;

import syntax.conditional_expression_unit;

import lex.lexer;
import lex.token;
import logger;

class AssignExpressionUnit {
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
      case Token.Type.Assign:
			case Token.Type.AddAssign:
			case Token.Type.SubAssign:
			case Token.Type.CatAssign:
			case Token.Type.MulAssign:
      case Token.Type.DivAssign:
      case Token.Type.ModAssign:
      case Token.Type.OrAssign:
      case Token.Type.AndAssign:
      case Token.Type.XorAssign:
      case Token.Type.ShiftLeftAssign:
      case Token.Type.ShiftRightAssign:
      case Token.Type.ShiftRightSignedAssign:
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
				auto expr = (new ConditionalExpressionUnit(_lexer, _logger)).parse;

        _state = 1;
				break;
		}

		return true;
	}
}
