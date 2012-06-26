/*
 * static_if_statement_unit.d
 *
 */

module syntax.static_if_statement_unit;

import syntax.assign_expression_unit;
import syntax.declaration_unit;

import lex.lexer;
import lex.token;
import logger;

final class StaticIfStatementUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	char[] parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

		return "";
	}

	bool tokenFound(Token token) {
		if (this._state == 3) {
			// We are looking for declarations
			if (token.type == Token.Type.RightCurly) {
				// Done.
				return false;
			}
			else {
				_lexer.push(token);
				auto decl = (new DeclarationUnit(_lexer, _logger)).parse;
			}
			return true;
		}

		// Else, we are looking for the condition

		switch (token.type) {
			// Look for a left paren first. It must exist.
			case Token.Type.LeftParen:
				if (this._state == 1) {
					// Error: Too many left parentheses.
					// TODO:
				}
				else if (this._state == 2) {
					// Error: We already found a right paren... Expected colon or brace
					// TODO:
				}
				this._state = 1;

				// The conditional part
				auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
				break;

			case Token.Type.RightParen:
				if (this._state == 0) {
					// Error: Do not have a left paren.
					// TODO: Probably forgot a left parenthesis.
				}
				else if (this._state == 2) {
					// Error: Too many right parens
					// TODO:
				}

				// Now we can look for a : or a curly brace for a declaration block
				this._state = 2;
				break;

			// For declaring the rest of the file under this conditional block
			// static if (foo):
			case Token.Type.Colon:
				if (this._state == 0) {
					// Error: Do not have a condition!
					// TODO:
				}
				else if (this._state == 1) {
					// Error: Do not have a right paren.
					// TODO:
				}
				else if (this._state == 3) {
					// Error: After a left curly brace. We are within the block.
					// TODO:
				}

				// Done.
				return false;

			// For specifying a declaration block for this condition
			case Token.Type.LeftCurly:
				if (this._state == 0) {
					// Error: Do not have a condition!
					// TODO:
				}
				else if (this._state == 1) {
					// Error: Do not have a right paren.
					// TODO:
				}

				// Now we look for declarations.
				this._state = 3;
				break;

			// Errors for any unknown tokens.
			default:
				break;
		}

		return true;
	}
}
