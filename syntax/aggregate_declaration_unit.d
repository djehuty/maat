/*
 * aggregate_declaration_unit.d
 *
 */

module syntax.aggregate_declaration_unit;

import syntax.aggregate_body_unit;

import lex.lexer;
import lex.token;
import logger;

class AggregateDeclarationUnit {
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
			// We have found the name
			case Token.Type.Identifier:
				if (_cur_string != "") {
					// Error: Two names?
				}
				_cur_string = token.string;
				break;

			// We have found the left brace, so parse the body
			case Token.Type.LeftCurly:
				auto aggregate_body = (new AggregateBodyUnit(_lexer, _logger)).parse;
				// Done.
				return false;

			case Token.Type.Semicolon:
				if (_cur_string == "") {
					// Error: No name?
				}
				// Done.
				return false;
			default:
				break;
		}
		return true;
	}
}
