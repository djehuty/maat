/*
 * volatile_statement_unit.d
 *
 */

module syntax.volatile_statement_unit;

import syntax.statement_unit;

import lex.lexer;
import lex.token;
import logger;

class VolatileStatementUnit {
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
			case Token.Type.Semicolon:
				// Done.
				return false;

			default:
				if (_state == 1) {
					// Error: Multiple statements!?
					// TODO:
				}

				_lexer.push(token);

				// Statement Follows.
				auto stml = (new StatementUnit(_lexer, _logger)).parse;
				_state = 1;

				break;
		}
		return true;
	}
}
