/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.volatilestmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.statementunit;

class VolatileStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Semicolon:
				// Done.
				return false;

			default:
				if (this.state == 1) {
					// Error: Multiple statements!?
					// TODO:
				}

				lexer.push(current);

				// Statement Follows.
				auto tree = expand!(StatementUnit)();
				this.state = 1;

				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
