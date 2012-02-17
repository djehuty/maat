/*
 * compare_expression_unit.d
 *
 */

module syntax.compare_expression_unit;

import lex.lexer;
import lex.token;
import logger;

import syntax.shift_expression_unit;

/*

	CmpExpr => ShiftExpr == ShiftExpr
	         | ShiftExpr != ShiftExpr
	         | ShiftExpr is ShiftExpr
	         | ShiftExpr !is ShiftExpr
	         | ShiftExpr < ShiftExpr
	         | ShiftExpr > ShiftExpr
	         | ShiftExpr <= ShiftExpr
	         | ShiftExpr >= ShiftExpr
	         | ShiftExpr !< ShiftExpr
	         | ShiftExpr !> ShiftExpr
	         | ShiftExpr !<= ShiftExpr
	         | ShiftExpr !>= ShiftExpr
	         | ShiftExpr !<> ShiftExpr
	         | ShiftExpr !<>= ShiftExpr
	         | ShiftExpr <> ShiftExpr
	         | ShiftExpr <>= ShiftExpr
	         | ShiftExpr in ShiftExpr
	         | ShiftExpr

*/

class CompareExpressionUnit {
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
			case Token.Type.Bang: // !
				// look for is
				Token foo = _lexer.pop();
				if (foo.type == Token.Type.Is) {
					// !is
					this._state = 2;
				}
				break;

			case Token.Type.Equals:						 // ==
			case Token.Type.NotEquals:					 // !=
			case Token.Type.LessThan:					 // <
			case Token.Type.NotLessThan:				 // !<
			case Token.Type.GreaterThan:				 // >
			case Token.Type.NotGreaterThan:				 // !>
			case Token.Type.LessThanEqual:				 // <=
			case Token.Type.NotLessThanEqual:			 // !<=
			case Token.Type.GreaterThanEqual:			 // >=
			case Token.Type.NotGreaterThanEqual:		 // !>=
			case Token.Type.LessThanGreaterThan:		 // <>
			case Token.Type.NotLessThanGreaterThan:		 // !<>
			case Token.Type.LessThanGreaterThanEqual:	 // <>=
			case Token.Type.NotLessThanGreaterThanEqual: // !<>=
			case Token.Type.Is:							 // is
			case Token.Type.In:							 // in

				if (this._state == 1) {
					// ==
					this._state = 2;
				}
				break;
			default:
				_lexer.push(token);
				if (this._state == 1) {
					// Done.
					return false;
				}

				auto expr = (new ShiftExpressionUnit(_lexer, _logger)).parse;
				if (this._state == 2) {
					// Done.
					return false;
				}
				this._state = 1;
				break;
		}
		return false;
	}
}
