/*
 * initializer_unit.d
 *
 */

module syntax.initializer_unit;

import syntax.assign_expression_unit;
import syntax.array_initializer_unit;

import lex.lexer;
import lex.token;
import logger;

/*

*/

class InitializerUnit {
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
			case Token.Type.Void:
        // Done
				return false;

			case Token.Type.LeftBracket:
				// Could be an ArrayInitializer
        auto expr = (new ArrayInitializerUnit(_lexer, _logger)).parse;

        // Done
				return false;

			case Token.Type.LeftCurly:
				// Could be a StructInitializer
				return false;

			default:
				// AssignExpression
				_lexer.push(token);
				auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
				return false;
		}
		return true;
	}
}
