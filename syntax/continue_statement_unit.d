/*
 * continue_statement_unit.d
 *
 */

module syntax.continue_statement_unit;

import lex.lexer;
import lex.token;
import logger;

/*

	continue
	ContinueStmt => ( Identifier )? ;

*/

class ContinueStatementUnit {
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
				// Done.
				return false;
			case Token.Type.Identifier:
				if (this._state == 1) {
					// Error: More than one identifier?!?!
					// TODO:
				}
				this._state = 1;
				_cur_string = token.string;
				break;
			default:
				// Error:
				// TODO:
				break;
		}
		return true;
	}
}
