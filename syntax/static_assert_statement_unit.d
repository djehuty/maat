/*
 * static_assert_statement_unit.d
 *
 */

module syntax.static_assert_statement_unit;

import lex.lexer;
import lex.token;
import logger;

class StaticAssertStatementUnit {
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
			default:
				break;
		}
		return true;
	}
}
