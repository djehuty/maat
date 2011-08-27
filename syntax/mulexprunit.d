/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.mulexprunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.unaryexprunit;

class MulExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Mul:
			case Token.Type.Div:
			case Token.Type.Mod:
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
				auto tree = expand!(UnaryExprUnit)();
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
