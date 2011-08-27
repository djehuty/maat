/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.continuestmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

class ContinueStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Semicolon:
				// Done.
				putln("Continue: ", cur_string);
				return false;
			case DToken.Identifier:
				if (this.state == 1) {
					// Error: More than one identifier?!?!
					// TODO:
				}
				this.state = 1;
				cur_string = current.value.toString();
				break;
			default:
				// Error:
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
