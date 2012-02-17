/*
 * throw_statement_unit.d
 *
 */

module syntax.throw_statement_unit;

import syntax.expression_unit;

import lex.lexer;
import lex.token;
import logger;

class ThrowStatementUnit {
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
				if (_state == 0) {
					// Error: No expression
					// TODO:
				}

				// Done.
				return false;
			default:
				if (_state == 1) {
					// Error: Multiple expressions
					// TODO:
				}
				_lexer.push(token);
				auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
				_state = 1;
				break;
		}
		return true;
	}
}
