/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module parsing.d.postfixexprlistunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.primaryexprunit;

import io.console;

import djehuty;

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
