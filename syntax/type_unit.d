/*
 * type_unit.d
 *
 */

module syntax.type_unit;

import lex.lexer;
import lex.token;
import logger;

class TypeUnit {
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
