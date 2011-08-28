/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.gotostmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.expressionunit;

/*

	goto
	GotoStmt => Identifier ;
	          | default ;
	          | case ( Expression )? ;

*/

class GotoStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Semicolon:
				if (this.state == 0) {
					// Error.
					// TODO:
				}
				if (this.state == 2) {
					// Error.
					// TODO:
				}
				// Done.
				return false;
			case Token.Type.Identifier:
				if (this.state != 0) {
					// Error
					// TODO:
				}
				cur_string = current.string;
				this.state = 1;
				break;
			case Token.Type.Default:
				this.state = 2;
				break;
			case Token.Type.Case:
				this.state = 2;
				break;
			default:
				if (this.state != 2) {
					// Error
					// TODO:
				}

				lexer.push(current);
				if (this.state == 3) {
					// Error: Multiple expressions
					// TODO:
				}
				auto tree = expand!(ExpressionUnit)();
				this.state = 3;
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
