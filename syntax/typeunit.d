/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.typeunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

class TypeUnit : ParseUnit {
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
