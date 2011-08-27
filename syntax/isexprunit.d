/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.isexprunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

class ExpressionUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Dot:
				break;

			default:
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
