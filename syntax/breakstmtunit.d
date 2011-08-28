/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.breakstmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

/*

	break
	BreakStmt => Identifier ;
	           | ;

*/

class BreakStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Semicolon:
				// Done.
				return false;
			case Token.Type.Identifier:
				if (this.state == 1) {
					// Error: More than one identifier?!?!
					// TODO:
				}
				this.state = 1;
				cur_string = current.string;
				break;
			default:
				// Error:
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
