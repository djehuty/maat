/*
 * static_statement_unit.d
 *
 */

module syntax.static_statement_unit;

import syntax.static_if_statement_unit;
import syntax.static_assert_statement_unit;

import lex.lexer;
import lex.token;
import logger;

class StaticStatementUnit {
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
			case Token.Type.If:
				// Static If (Compile-time condition)
				// static if ...
				auto stmt = (new StaticIfStatementUnit(_lexer, _logger)).parse;
				break;
			case Token.Type.Assert:
				// Static Assert (Compile-time assert)

				// static assert ...
				auto stmt = (new StaticAssertStatementUnit(_lexer, _logger)).parse;
				break;
			case Token.Type.This:
				// Static Constructor

				// static this ...
				break;
			case Token.Type.Cat:
				// Static Destructor

				// static ~ this ...
				break;
			default:
				// Attribute Specifier
				// static Type
				break;
		}
		return true;
	}
}
