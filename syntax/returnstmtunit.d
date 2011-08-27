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

class ReturnStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Semicolon:
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
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
