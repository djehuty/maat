/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.primaryexprunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

class PrimaryExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.StringLiteral:
				cur_string = current.string;
				return false;
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
