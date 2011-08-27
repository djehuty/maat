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

/*

	UnaryExpr => & UnaryExpr
	           | ++ UnaryExpr
			   | -- UnaryExpr
			   | * UnaryExpr
			   | - UnaryExpr
			   | + UnaryExpr
			   | ! UnaryExpr
			   | ~ UnaryExpr
			   | ( Type ) . Identifier
			   | NewExpr
			   | DeleteExpr
			   | CastExpr
			   | NewAnonClassExpr
			   | PostfixExpr

*/

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
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
