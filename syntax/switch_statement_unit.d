/*
 * switch_statement_unit.d
 *
 */

module syntax.switch_statement_unit;

import syntax.expression_unit;
import syntax.block_statement_unit;

import lex.lexer;
import lex.token;
import logger;

class SwitchStatementUnit {
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
				if (_state != 0) {
				}

				auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
				_state = 1;
				break;
			case Token.Type.RightParen:
				if (_state != 1) {
				}
				_state = 2;
				break;
			case Token.Type.LeftCurly:
				if (_state == 0) {
				}
				if (_state == 1) {
				}

				auto stmt = (new BlockStatementUnit(_lexer, _logger)).parse;
				// Done.
				return false;
			default:
				// Error
				// TODO:
				break;
		}
		return true;
	}
}
