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

class ScopedStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {

			// Statement Blocks
			case DToken.LeftCurly:
				this.state = 1;
				break;

			case DToken.RightCurly:
				if (this.state != 1) {
				}
				return false;

			case DToken.Semicolon:
				// Error.
				return false;

			default:
				// Just a statement
				auto tree = expand!(StatementUnit)();
				if (this.state == 0) {
					return false;
				}
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
