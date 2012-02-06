/*
 * primaryexprunit.d
 *
 * This module parses expressions consisting of a single term.
 *
 */

module syntax.primaryexprunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import tango.io.Stdout;

class PrimaryExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.StringLiteral:
				cur_string = current.string;
				return false;
			case Token.Type.IntegerLiteral:
				Stdout("Value: ")(current.integer).newline;
				return false;
			case Token.Type.Identifier:
				Stdout("Variable: ")(current.string).newline;
				return false;
			default:
				Stdout("Primary Expr Default").newline;
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
