/*
 * interface_body_unit.d
 *
 */

module syntax.interface_body_unit;

import syntax.declaration_unit;

import lex.lexer;
import lex.token;
import logger;

class InterfaceBodyUnit {
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
			// We are always looking for the end of the body.
			case Token.Type.RightCurly:
				// Done.
				return false;

			// We cannot have allocators in interfaces!
			case Token.Type.New:
				// Error: No allocators allowed.
				// TODO:
				break;

			// Ditto for a delete token for deallocator.
			case Token.Type.Delete:
				// Error: No deallocators allowed.
				// TODO:
				break;

			// Otherwise, it must be some Declarator
			default:
				_lexer.push(token);
				auto decl = (new DeclarationUnit(_lexer, _logger)).parse;
				break;
		}
		return true;
	}
}
