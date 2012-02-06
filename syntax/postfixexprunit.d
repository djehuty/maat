/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.postfixexprunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.postfixexprlistunit;

class PostFixExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Mixin:
				// TODO: MixinExprUnit
//				auto tree = expand!(MixinExprUnit)();
				break;
			case Token.Type.Assert:
				// TODO: AssertExprUnit
//				auto tree = expand!(AssertExprUnit)();
				break;
			case Token.Type.Is:
				// TODO: IsExprUnit
//				auto tree = expand!(IsExprUnit)();
				break;
			default:
				lexer.push(current);
				auto tree = expand!(PostFixExprListUnit)();
				return false;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
