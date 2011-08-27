/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.functionbodyunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.parameterlistunit;
import syntax.functionbodyunit;
import syntax.statementunit;

class FunctionBodyUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {

			// We always look FIRST for a left curly brace
			case DToken.LeftCurly:
				if (this.state % 2 == 1) {
					// Error: Left curly already found.
					// TODO:
				}
				this.state = this.state + 1;
				break;

			// We are always looking for the end of the block.
			case DToken.RightCurly:
				if (this.state % 2 == 0) {
					// Error: Left curly not found!
					// TODO:
				}
				this.state = this.state - 1;

				if (this.state == 0) {
					// Done.
					return false;
				}

			// TODO: in, out, body, blockstatement foo
			case DToken.In:
				break;
			case DToken.Out:
				break;
			case DToken.Body:
				break;

			default:
				lexer.push(current);
				if (this.state % 2 == 0) {
				}
				auto tree = expand!(StatementUnit)();
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
