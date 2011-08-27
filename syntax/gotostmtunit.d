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

class GotoStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Semicolon:
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
			case DToken.Identifier:
				if (this.state != 0) {
					// Error
					// TODO:
				}
				Console.putln("Goto: ", current.value);
				cur_string = current.value.toString();
				this.state = 1;
				break;
			case DToken.Default:
				Console.putln("Goto: Default");
				this.state = 2;
				break;
			case DToken.Case:
				Console.putln("Goto: Case");
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
