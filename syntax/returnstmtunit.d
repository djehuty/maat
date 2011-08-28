/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.returnstmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.expressionunit;

/*

	return
	ReturnStmt => ( Expression )? ;

*/

class ReturnStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Semicolon:
				// Done.
				return false;

			default:
				if (this.state == 1) {
					// Error: Multiple expressions
					// TODO:
				}

				lexer.push(current);

				// Expression follows... and then a semicolon
				auto tree = expand!(ExpressionUnit)();
				this.state = 1;

				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
