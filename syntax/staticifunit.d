/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.staticifunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.assignexprunit;
import syntax.declarationunit;

class StaticIfUnit : ParseUnit {
	override bool tokenFound(Token current) {
		if (this.state == 3) {
			// We are looking for declarations
			if (current.type == Token.Type.RightCurly) {
				// Done.
				return false;
			}
			else {
				lexer.push(current);
				auto tree = expand!(DeclarationUnit)();
			}
			return true;
		}

		// Else, we are looking for the condition

		switch (current.type) {
			// Look for a left paren first. It must exist.
			case Token.Type.LeftParen:
				if (this.state == 1) {
					// Error: Too many left parentheses.
					// TODO:
				}
				else if (this.state == 2) {
					// Error: We already found a right paren... Expected colon or brace
					// TODO:
				}
				this.state = 1;

				// The conditional part
				auto tree = expand!(AssignExprUnit)();
				break;

			case Token.Type.RightParen:
				if (this.state == 0) {
					// Error: Do not have a left paren.
					// TODO: Probably forgot a left parenthesis.
				}
				else if (this.state == 2) {
					// Error: Too many right parens
					// TODO:
				}

				// Now we can look for a : or a curly brace for a declaration block
				this.state = 2;
				break;

			// For declaring the rest of the file under this conditional block
			// static if (foo):
			case Token.Type.Colon:
				if (this.state == 0) {
					// Error: Do not have a condition!
					// TODO:
				}
				else if (this.state == 1) {
					// Error: Do not have a right paren.
					// TODO:
				}
				else if (this.state == 3) {
					// Error: After a left curly brace. We are within the block.
					// TODO:
				}

				// Done.
				return false;

			// For specifying a declaration block for this condition
			case Token.Type.LeftCurly:
				if (this.state == 0) {
					// Error: Do not have a condition!
					// TODO:
				}
				else if (this.state == 1) {
					// Error: Do not have a right paren.
					// TODO:
				}

				// Now we look for declarations.
				this.state = 3;
				break;

			// Errors for any unknown tokens.
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
