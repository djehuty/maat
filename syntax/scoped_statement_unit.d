/*
 * scoped_statement_unit.d
 *
 */

module syntax.scoped_statement_unit;

import syntax.statement_unit;

import lex.lexer;
import lex.token;
import logger;

class ScopedStatementUnit {
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
			// Statement Blocks
			case Token.Type.LeftCurly:
				this._state = 1;
				break;

			case Token.Type.RightCurly:
				if (this._state != 1) {
				}
				return false;

			case Token.Type.Semicolon:
				// Error.
				return false;

			default:
				// Just a statement
				_lexer.push(token);
				auto stmt = (new StatementUnit(_lexer, _logger)).parse;
				if (this._state == 0) {
					return false;
				}
				break;
		}
		return true;
	}
}
