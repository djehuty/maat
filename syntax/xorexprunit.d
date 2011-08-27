/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.xorexprunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.andexprunit;

/*

	XorExpr => XorExpr ^ AndExpr
             | AndExpr	

*/

class XorExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Xor:
				if (this.state == 1) {
					this.state = 0;
					break;
				}

				// Fall through
				goto default;

			default:
				lexer.push(current);
				if (this.state == 1) {
					// Done.
					return false;
				}
				auto tree = expand!(AndExprUnit)();
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
