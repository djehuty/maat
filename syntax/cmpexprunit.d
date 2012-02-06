/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.cmpexprunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.shiftexprunit;

import tango.io.Stdout;

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

class CmpExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Bang: // !
				// look for is
				Token foo = lexer.pop();
				if (foo.type == Token.Type.Is) {
					// !is
					this.state = 2;
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

				if (this.state == 1) {
					// ==
					this.state = 2;
				}
				break;
			default:
				lexer.push(current);
				if (this.state == 1) {
					// Done.
					return false;
				}

				auto tree = expand!(ShiftExprUnit)();
				if (this.state == 2) {
					// Done.
					return false;
				}
				this.state = 1;
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
