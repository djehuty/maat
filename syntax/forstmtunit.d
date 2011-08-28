/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.forstmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.statementunit;
import syntax.scopedstmtunit;
import syntax.expressionunit;

/*

	for
	ForStmt => ( NoScopeNonEmptyStmt ; Increment ) ScopeStmt
	         | ( NoScopeNonEmptyStmy ; ; ) ScopeStmt
	         | ( ; Expression ; Increment ) ScopeStmt
	         | ( ; Expression ; ) ScopeStmt
	         | ( ; ; Increment ) ScopeStmt
	         | ( ; ; ) ScopeStmt

*/

class ForStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.LeftParen:
				auto tree = expand!(StatementUnit)();
				this.state = 1;
				break;

			case Token.Type.RightParen:
				if (this.state < 3 || this.state > 4) {
				}

				// Found end of for loop expressions
				this.state = 5;
				auto tree = expand!(ScopedStmtUnit)();
				break;

			case Token.Type.Semicolon:
				if (this.state == 0) {
				}

				if (this.state == 1) {
					// No expression.
					this.state = 3;
				}
				else if (this.state == 2) {
					// Had expression, looking for end
					// or loop expression
					this.state = 3;
				}
				break;

			// We have an expression here.	
			default:
				if (this.state == 1) {
					// Invariant Expression
					lexer.push(current);
					auto tree = expand!(ExpressionUnit)();
					this.state = 2;
				}
				else if (this.state == 3) {
					// Loop expression
					lexer.push(current);
					auto tree = expand!(ExpressionUnit)();
					this.state = 4;
				}
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
