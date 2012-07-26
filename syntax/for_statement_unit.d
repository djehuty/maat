/*
 * for_statement_unit.d
 *
 */

module syntax.for_statement_unit;

import syntax.scoped_statement_unit;
import syntax.statement_unit;
import syntax.block_statement_unit;
import syntax.expression_unit;

import lex.lexer;
import lex.token;
import logger;

/*

	for
	ForStmt => ( NoScopeNonEmptyStmt ; Increment ) ScopeStmt
	         | ( NoScopeNonEmptyStmt ; ; ) ScopeStmt
	         | ( ; Expression ; Increment ) ScopeStmt
	         | ( ; Expression ; ) ScopeStmt
	         | ( ; ; Increment ) ScopeStmt
	         | ( ; ; ) ScopeStmt

*/

class ForStatementUnit {
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
		switch (token.type) {
			case Token.Type.LeftParen:
        if (_state == 0) {
          _state = 1;
          break;
        }
        goto default;

			case Token.Type.RightParen:
				if (_state < 4 || _state > 5) {
				}

				// Found end of for loop expressions
				_state = 6;
				auto stmt = (new ScopedStatementUnit(_lexer, _logger)).parse;
        return false;

			case Token.Type.Semicolon:
				if (_state == 0) {
				}

				if (_state == 1) {
					// No expression.
					_state = 2;
				}
				else if (_state == 2 || _state == 3) {
					// Had expression, looking for end
					// or loop expression
					_state = 4;
				}
				break;

			// We have an expression here.	
			default:
				if (_state == 1) {
          // Initialization Expression
					_lexer.push(token);
					auto stmt = (new StatementUnit(_lexer, _logger)).parse;
          _state = 2;
        }
        else if (_state == 2) {
					// Invariant Expression
					_lexer.push(token);
					auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
					_state = 3;
				}
				else if (_state == 4) {
					// Loop expression
					_lexer.push(token);
					auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
					_state = 5;
				}
				break;
		}
		return true;
	}
}
