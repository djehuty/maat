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

/*

	default
	DefaultStmt => :

*/

class DefaultStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Colon:
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
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
