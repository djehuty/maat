/*
 * functionbodyunit.d
 *
 * This module parses function bodies.
 *
 */

module syntax.functionbodyunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.blockstmtunit;

class FunctionBodyUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {

			// We always look FIRST for a left curly brace
			case Token.Type.LeftCurly:
				auto tree = expand!(BlockStmtUnit)();
				break;

			// TODO: in, out, body, blockstatement foo
			case Token.Type.In:
				if (state & 1 > 0) {
					// Bad (In already found)
				}
				if (state & 4 > 0) {
					// Bad (Body already found)
				}
				state = state | 1;
				break;
			case Token.Type.Out:
				if (state & 2 > 0) {
					// Bad (Out already found)
				}
				if (state & 4 > 0) {
					// Bad (Body already found)
				}
				state = state | 2;
				break;
			case Token.Type.Body:
				state = state | 4;
				break;

			default:
				lexer.push(current);
				return false;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
