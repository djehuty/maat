/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.throwstmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.expressionunit;

class ThrowStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Semicolon:
				if (this.state == 0) {
					// Error: No expression
					// TODO:
				}

				// Done.
				return false;
			default:
				if (this.state == 1) {
					// Error: Multiple expressions
					// TODO:
				}
				lexer.push(current);
				auto tree = expand!(ExpressionUnit)();
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
