/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.unaryexprunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.postfixexprunit;

class UnaryExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			default:
				lexer.push(current);
				auto tree = expand!(PostFixExprUnit)();
				break;
		}
		return false;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
