/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.staticassertunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

class StaticAssertUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			default:
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
