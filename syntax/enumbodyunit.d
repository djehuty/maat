/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.enumbodyunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.assignexprunit;

class EnumBodyUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {

			// Looking for a new member name
			case Token.Type.Identifier:
				if (this.state == 1) {
					// Error: A name next to a name??
				}
				this.state = 1;
				break;
			case Token.Type.RightCurly:
				// Done.
				return false;
			case Token.Type.Comma:
				if (this.state != 1) {
					// Error: A comma by itself?
				}
				this.state = 0;
				break;
			case Token.Type.Assign:
				if (this.state != 1) {
					// Error: An equals by itself?
				}

				// Look for an assignment expression.
				auto tree = expand!(AssignExprUnit)();

				// Stay in the same state and wait for a comma.
				break;
			default:
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
