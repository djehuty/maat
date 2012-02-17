/*
 * goto_statement_unit.d
 *
 */

module syntax.goto_statement_unit;

import syntax.expression_unit;

import lex.lexer;
import lex.token;
import logger;

/*

	goto
	GotoStmt => Identifier ;
	          | default ;
	          | case ( Expression )? ;

*/

class GotoStatementUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

	char[] _cur_string;

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
					// Error.
					// TODO:
				}
				if (_state == 2) {
					// Error.
					// TODO:
				}
				// Done.
				return false;
			case Token.Type.Identifier:
				if (_state != 0) {
					// Error
					// TODO:
				}
				_cur_string = token.string;
				_state = 1;
				break;
			case Token.Type.Default:
				_state = 2;
				break;
			case Token.Type.Case:
				_state = 2;
				break;
			default:
				if (_state != 2) {
					// Error
					// TODO:
				}

				_lexer.push(token);
				if (_state == 3) {
					// Error: Multiple expressions
					// TODO:
				}
				auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
				_state = 3;
				break;
		}
		return true;
	}
}
