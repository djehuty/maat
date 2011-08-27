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

class ForStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.LeftParen:
				Console.putln("For: ");
				auto tree = expand!(StatementUnit)();
				this.state = 1;
				break;

			case DToken.RightParen:
				if (this.state < 3 || this.state > 4) {
				}

				// Found end of for loop expressions
				this.state = 5;
				auto tree = expand!(ScopedStmtUnit)();
				break;

			case DToken.Semicolon:
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
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
