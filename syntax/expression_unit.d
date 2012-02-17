/*
 * expressionunit.d
 *
 */

module syntax.expression_unit;

import syntax.assign_expression_unit;

import lex.lexer;
import lex.token;
import logger;

class ExpressionUnit {
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
		if (token.type == Token.Type.Comment) {
			return false;
		}

		_lexer.push(token);
		auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
		return false;
	}
}
