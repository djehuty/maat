/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.conditionalexprunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.logicalorexprunit;

class ConditionalExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			default:
				lexer.push(current);
				auto tree = expand!(LogicalOrExprUnit)();
		}
				return false;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
