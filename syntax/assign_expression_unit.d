/*
 * assign_expression_unit.d
 *
 */

module syntax.assign_expression_unit;

import syntax.conditional_expression_unit;

import lex.lexer;
import lex.token;
import logger;

class AssignExpressionUnit {
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
				_lexer.push(token);
				auto expr = (new ConditionalExpressionUnit(_lexer, _logger)).parse;
				break;
		}
		return false;
	}
}
