/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.logicalorexprunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.logicalandexprunit;

class LogicalOrExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.LogicalOr:
				if (this.state == 1) {
					Console.putln("OROR");
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
				auto tree = expand!(LogicalAndExprUnit)();
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
