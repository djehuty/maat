/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.logicalandexprunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.orexprunit;

class LogicalAndExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.LogicalAnd:
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
				auto tree = expand!(OrExprUnit)();
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
