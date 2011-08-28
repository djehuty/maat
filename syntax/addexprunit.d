/*
 * addexprunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.addexprunit;

import lex.token;

import syntax.parseunit;

import syntax.nodes;

import syntax.mulexprunit;

/*

	AddExpr => AddExpr + MulExpr
	         | AddExpr - MulExpr
	         | AddExpr ~ MulExpr
	         | MulExpr

*/

class AddExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Add:
			case Token.Type.Sub:
			case Token.Type.Cat:
				if (this.state == 1) {
					this.state = 0;
					break;
				}

				// Fall through

			default:
				lexer.push(current);
				if (this.state == 1) {
					// Done.
					return false;
				}
				auto tree = expand!(MulExprUnit)();
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
