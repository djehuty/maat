/*
 * conditional_expression_unit.d
 *
 */

module syntax.conditional_expression_unit;

import lex.lexer;
import lex.token;
import logger;

import syntax.logical_or_expression_unit;

/*

   ConditionalExpr => LogicalOrExpr ? Expression : ConditionalExpr
                    | LogicalOrExpr

*/

class ConditionalExpressionUnit {
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
				auto tree = (new LogicalOrExpressionUnit(_lexer, _logger)).parse;
				break;
		}
		return false;
	}
}
