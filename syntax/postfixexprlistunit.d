/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.postfixexprlistunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.primaryexprunit;

class PostFixExprListUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			default:
				lexer.push(current);
				auto tree = expand!(PrimaryExprUnit)();
		}
				return false;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
