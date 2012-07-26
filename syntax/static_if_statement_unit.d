/*
 * static_if_statement_unit.d
 *
 */

module syntax.static_if_statement_unit;

import syntax.assign_expression_unit;
import syntax.declaration_unit;
import syntax.scoped_statement_unit;

import ast.declaration_node;

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
	
	DeclarationNode parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

		return null;
	}

	bool tokenFound(Token token) {
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
        _lexer.push(token);
        auto stmt = (new ScopedStatementUnit(_lexer, _logger)).parse;
        _state = 3;
        break;

      case Token.Type.Else:
        if (_state == 3) {
          auto stmt = (new ScopedStatementUnit(_lexer, _logger)).parse;
          return false;
        }
        goto default;

			default:
        if (_state == 3) {
          _lexer.push(token);
          return false;
        }

				break;
		}

		return true;
	}
}
