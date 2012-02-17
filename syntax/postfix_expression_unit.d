/*
 * postfix_expression_unit.d
 *
 */

module syntax.postfix_expression_unit;

import lex.lexer;
import lex.token;
import logger;

import syntax.primary_expression_unit;

/*


*/

class PostfixExpressionUnit {
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

		switch (token.type) {
			default:
				_lexer.push(token);
				auto expr = (new PrimaryExpressionUnit(_lexer, _logger)).parse;
				break;
		}
		return false;
	}
}
