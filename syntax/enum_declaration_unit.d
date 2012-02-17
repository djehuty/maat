/*
 * enum_declaration_unit.d
 *
 */

module syntax.enum_declaration_unit;

import syntax.enum_body_unit;
import syntax.type_unit;

import lex.lexer;
import lex.token;
import logger;

class EnumDeclarationUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

	char[] _cur_string;

	char[] cur_string = "";

	static const char[] _common_error_msg = "Enum declaration is invalid.";
	static const char[][] _common_error_usages = null;

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
		// Looking for a name, or a colon for a type, or a curly
		// braces for the enum body
		switch (token.type) {
			case Token.Type.Identifier:
				// The name of the enum
				if (_state >= 1) {
					// We are already passed the name stage.
					// XXX: error
				}
				_state = 1;
				_cur_string = token.string;
				break;
			case Token.Type.Colon:
				// The type of the enum
				if (_state >= 2) {
					// Already passed the type stage.
					// XXX: error
				}
				_state = 2;
				auto type = (new TypeUnit(_lexer, _logger)).parse;
				break;
			case Token.Type.Semicolon:
				if (_state == 0) {
					// Need some kind of information about the enum.
					_logger.error(_lexer, token, _common_error_msg,
							"Without a name, the linker will not know what it should be linking to.",
							["enum FooBar;", "enum FooBar : uint;"]);
					return false;
				}
				// Done.
				return false;
			case Token.Type.LeftCurly:
				// We are going into the body of the enum
				auto enum_body = (new EnumBodyUnit(_lexer, _logger)).parse;
				// Done.
				return false;
			default:
				break;
		}
		return true;
	}
}
