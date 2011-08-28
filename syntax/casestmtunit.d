/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.casestmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.expressionunit;

/*

	case
	CaseStmt => Expression ( , Expression )* :

*/

class CaseStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Colon:
				if (this.state == 0) {
					// Error:
					// we have 'case: '
					// TODO:
				}

				// Done.
				return false;
			default:
				lexer.push(current);
				if (this.state == 1) {
					// Error: Multiple expressions
					// TODO:
				}
				auto tree = expand!(ExpressionUnit)();
				this.state = 1;
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
