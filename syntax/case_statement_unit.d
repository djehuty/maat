/*
 * case_statement_unit.d
 *
 */

module syntax.case_statement_unit;

import syntax.expression_unit;

import lex.lexer;
import lex.token;
import logger;

class CaseStatementUnit {
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
			case Token.Type.Colon:
				if (this._state == 0) {
					// Error:
					// we have 'case: '
					// TODO:
				}

				// Done.
				return false;
			default:
				_lexer.push(token);
				if (this._state == 1) {
					// Error: Multiple expressions
					// TODO:
				}
				auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
				this._state = 1;
				break;
		}
		return true;
	}
}
