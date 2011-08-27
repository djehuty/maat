/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.switchstmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.expressionunit;
import syntax.blockstmtunit;

class SwitchStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.LeftParen:
				if (this.state != 0) {
				}

				auto tree = expand!(ExpressionUnit)();
				this.state = 1;
				break;
			case Token.Type.RightParen:
				if (this.state != 1) {
				}
				this.state = 2;
				break;
			case Token.Type.LeftCurly:
				if (this.state == 0) {
				}
				if (this.state == 1) {
				}

				auto tree = expand!(BlockStmtUnit)();
				// Done.
				return false;
			default:
				// Error
				// TODO:
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
