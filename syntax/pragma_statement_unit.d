/*
 * pragma_statement_unit.d
 *
 */

module syntax.pragma_statement_unit;

import lex.lexer;
import lex.token;
import logger;

class PragmaStatementUnit {
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
			case Token.Type.LeftParen:
				if(this._state >= 1){
					//XXX: Error
				}

				this._state = 1;
				break;
			case Token.Type.Identifier:
				if(this._state != 1){
					//XXX: Error
				}

				_cur_string = token.string;
				this._state = 2;
				break;
			case Token.Type.RightParen:
				if(this._state != 2 && this._state != 3){
					//XXX: Error
				}

				if (this._state == 2) {
					//auto tree = expand!(StatementUnit)();
				}

				// Done.
				return false;
			case Token.Type.Comma:
				if(this._state != 2){
					//XXX: Error
				}

				this._state = 3;

				//TODO: Argument List
				
				break;
			default:
				break;
		}
		return true;
	}
}
