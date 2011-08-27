/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.unittestunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.functionbodyunit;

class UnittestUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			// Look for the beginning of a functionbody
			case Token.Type.In:
			case Token.Type.Out:
			case Token.Type.Body:
			case Token.Type.LeftCurly:
				lexer.push(current);
				auto tree = expand!(FunctionBodyUnit)();
				
				// Done.
				return false;

			// Errors otherwise.
			default:
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
