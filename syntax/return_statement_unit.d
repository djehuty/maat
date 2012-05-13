/*
 * return_statement_unit.d
 *
 */

module syntax.return_statement_unit;

import syntax.expression_unit;

import lex.lexer;
import lex.token;
import logger;

/*

	return
	ReturnStmt => ( Expression )? ;

*/

class ReturnStatementUnit {
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
			if (_logger.errors) {
				return null;
			}
		} while (tokenFound(token));

		return "";
	}

	bool tokenFound(Token token) {
		switch (token.type) {
			case Token.Type.Semicolon:
				// Done.
				return false;

			default:
				if (_state == 1) {
					// Error: Multiple expressions
					// TODO:
          _logger.error(_lexer, token,
            "There are two expressions given for this return statement.",
            "Did you mean to place a semicolon between the two?",
            ["return;", "return 3", "return 2+2;"]);
          return true;
				}

				_lexer.push(token);

				// Expression follows... and then a semicolon
				auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
				_state = 1;
				break;
		}
		return true;
	}
}
