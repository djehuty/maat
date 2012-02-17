/*
 * parameter_list_unit.d
 *
 */

module syntax.parameter_list_unit;

import syntax.parameter_unit;

import lex.lexer;
import lex.token;
import logger;

/*

	(
	ParameterList => Parameter , ParameterList
	               | Parameter )
	               | )

*/

class ParameterListUnit {
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
			case Token.Type.RightParen:
				// Done.
				return false;

			case Token.Type.Variadic:
				if (_state == 2) {
					// Error: Have two variadics?!
					// TODO: One too many variadics.
				}
				// We have a variadic!
				_state = 2;
				break;

			case Token.Type.Comma:
				if (_state == 0) {
					// Error: Expected a parameter!
					// TODO: Probably accidently removed a parameter without removing the comma.
				}

				// Get Parameter
				_state = 0;
				break;

			default:
				if (_state == 0) {
					// Look for a parameter
					_lexer.push(token);
					auto param = (new ParameterUnit(_lexer, _logger)).parse;
					_state = 1;
				}
				else if (_state == 2) {
					// Error: Parameter after variadic?
					// TODO: Forgot comma.
				}
				else {
					// Error: otherwise
					// TODO:
				}

				break;
		}
		return true;
	}
}
