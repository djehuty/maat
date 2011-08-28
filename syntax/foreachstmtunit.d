/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.foreachstmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.expressionunit;
import syntax.scopedstmtunit;
import syntax.typeunit;

/*

	ForeachStmt => ( ForeachTypeList ; Expression ) ScopeStmt
	             | ( ForeachTypeList ; Tuple ) ScopeStmt

	ForeachTypeList => ForeachType , ForeachTypeList
	                 | ForeachType

	ForeachType => ref Type Identifier
	             | Type Identifier
	             | ref Identifier
	             | Identifier

*/

class ForeachStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.LeftParen:
				if (this.state > 0) {
					// Error: Already found left parenthesis.
					// TODO:
				}
				this.state = 1;
				break;
			case Token.Type.RightParen:
				if (this.state != 5) {
				}
				auto tree = expand!(ScopedStmtUnit)();
				return false;
			case Token.Type.Ref:
				if (this.state == 0) {
				}
				else if (this.state >= 2) {
				}
				this.state = 2;
				break;
			case Token.Type.Identifier:
				if (this.state == 0) {
				}
				if (this.state > 3) {
				}
				if (this.state == 3) {
					this.state = 4;
				}
				else {
					// This needs lookahead to know it isn't a type
					Token foo = lexer.pop();
					lexer.push(foo);
					if (foo.type == Token.Type.Comma || foo.type == Token.Type.Semicolon) {
						this.state = 4;
					}
					else {
						lexer.push(current);
	
						// Getting type of identifier
						auto tree = expand!(TypeUnit)();
	
						this.state = 3;
					}
				}

				if (this.state == 4) {
				}
				break;
			case Token.Type.Semicolon:
				if (this.state < 4) {
				}
				auto tree = expand!(ExpressionUnit)();
				this.state = 5;
				break;
			case Token.Type.Comma:
				if (this.state != 4) {
				}
				this.state = 1;
				break;
			default:
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
