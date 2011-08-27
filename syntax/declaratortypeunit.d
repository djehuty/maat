/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.declaratortypeunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

class DeclaratorTypeUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
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
