/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.scopedstmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.statementunit;

import tango.io.Stdout;

class ScopedStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {

			// Statement Blocks
			case Token.Type.LeftCurly:
				this.state = 1;
				break;

			case Token.Type.RightCurly:
				if (this.state != 1) {
				}
				return false;

			case Token.Type.Semicolon:
				// Error.
				return false;

			default:
				// Just a statement
				lexer.push(current);
				auto tree = expand!(StatementUnit)();
				if (this.state == 0) {
					return false;
				}
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
