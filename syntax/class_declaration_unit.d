/*
 * class_declaration_unit.d
 *
 */

module syntax.class_declaration_unit;

import syntax.class_body_unit;

import ast.class_node;

import lex.lexer;
import lex.token;
import logger;

class ClassDeclarationUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;
	
	char[] _cur_string;

	ClassNode _classNode;

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	ClassNode parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

		return _classNode;
	}

	bool tokenFound(Token token) {
		switch (token.type) {
			// The start of the body
			case Token.Type.LeftCurly:
				auto classBody = (new ClassBodyUnit(_lexer, _logger)).parse;
				_classNode = new ClassNode(_cur_string, classBody[0], classBody[1][0], classBody[2]);

				// Done.
				return false;

			// Look for a template parameter list
			case Token.Type.LeftParen:
				if (_cur_string == "") {
					// Error: No name?
					// TODO:
				}
				if (_state >= 1) {
					// Error: Already have base class list or template parameters
					// TODO:
				}
				_state = 1;

				// TODO: expand out parameter list				
				break;

			// Look for inherited classes
			case Token.Type.Colon:
				if (_cur_string == "") {
					// Error: No name?
					// TODO:
				}
				if (_state >= 2) {
					// Error: Already have base class list
					// TODO:
				}
				_state = 2;

				// TODO: expand out base class list
				break;

			// Name
			case Token.Type.Identifier:
				if (_cur_string != "") {
					// Error: Two names?
					// TODO:
				}
				_cur_string = token.string;
				break;

			default:
				// Error: Unrecognized foo.
				break;
		}
		return true;
	}
}
