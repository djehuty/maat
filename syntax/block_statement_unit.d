/*
 * block_statement_unit.d
 *
 */

module syntax.block_statement_unit;

import syntax.statement_unit;

import lex.lexer;
import lex.token;
import logger;

import tango.io.Stdout;

class BlockStatementUnit {
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
			case Token.Type.RightCurly:
				// Done.
				return false;
			default:
				// We can look for a simple declaration
				_lexer.push(token);
				auto stmt = (new StatementUnit(_lexer, _logger)).parse;

				Stdout("Statement Consumed").newline;
				break;
		}
		return true;
	}
}
