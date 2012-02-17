/*
 * unit_test_unit.d
 *
 */

module syntax.unit_test_unit;

import syntax.function_body_unit;

import lex.lexer;
import lex.token;
import logger;

class UnitTestUnit {
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
			// Look for the beginning of a functionbody
			case Token.Type.In:
			case Token.Type.Out:
			case Token.Type.Body:
			case Token.Type.LeftCurly:
				_lexer.push(token);
				auto test_body = (new FunctionBodyUnit(_lexer, _logger)).parse;
				
				// Done.
				return false;

			// Errors otherwise.
			default:
				break;
		}
		return true;
	}
}
