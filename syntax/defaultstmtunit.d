/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.defaultstmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

class DefaultStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Colon:
				Console.putln("Default:");
				// Done.
				return false;
			default:
				// Error: Default does not allow expressions
				// TODO:
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
