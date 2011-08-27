/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.expressionunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.assignexprunit;

class ExpressionUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			default:
				lexer.push(current);
				auto tree = expand!(AssignExprUnit)();
		}
				return false;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
