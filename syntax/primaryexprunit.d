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
			case DToken.StringLiteral:
				Console.putln("Expression: \"", current.value, "\"");
				cur_string = current.value.toString();
				return false;
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
