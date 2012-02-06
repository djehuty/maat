/*
 * ifstmtunit.d
 *
 * This module parses if statements.
 *
 */

module syntax.ifstmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.statementunit;
import syntax.scopedstmtunit;
import syntax.expressionunit;
import syntax.declaratorunit;

import tango.io.Stdout;

/*

	if
	IfStmt => ( IfCondition ) ScopeStatement ( else ScopeStatement )?

	IfCondition => Expression
	             | auto Identifier = Expression
				 | BasicType Declarator = Expression

*/

class IfStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch(state) {
			case 0:
				switch (current.type) {
					case Token.Type.LeftParen:
						state = 1;
						break;

					case Token.Type.RightParen:
					case Token.Type.Semicolon:
						// Bad
						break;

					default:
						break;
				}
				break;

			case 1: // IfCondition
				switch (current.type) {
					case Token.Type.Auto:
						state = 2;
						break;
					default:
						// Expression
						lexer.push(current);
						auto tree = expand!(ExpressionUnit)();
						state = 4;
						break;
				}
				break;
			case 2: // IfCondition: auto... Identifier = Expression
				switch (current.type) {
					case Token.Type.Identifier:
						state = 3;
						break;
					default:
						// Bad
						break;
				}
				break;
			case 3: // IfCondition: auto Identifier... = Expression
				switch (current.type) {
					case Token.Type.Assign:
						auto tree = expand!(ExpressionUnit)();
						state = 4;
						break;
					default:
						// Bad
						break;
				}
				break;
			case 4: // IfCondition consumed
				switch (current.type) {
					case Token.Type.RightParen:
						// Good
						auto tree = expand!(ScopedStmtUnit)();
						state = 5;
						break;
					default:
						// Bad
						break;
				}
				break;
			case 5: // ( IfCondition ) ScopeStatement ... else ScopeStatement
				switch (current.type) {
					case Token.Type.Else:
						// Alright
						auto tree = expand!(ScopedStmtUnit)();
						break;

					default:
						// Fine
						lexer.push(current);
						break;
				}
				return false;
		}

		return true;
	}

	protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
