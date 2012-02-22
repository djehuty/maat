/*
 * module_declaration_unit.d
 *
 * This module parses out the 'identifier.foo.bar' stuff out of a module
 * or import _statement.
 *
 * Author: Dave Wilkinson
 * Originated: February 6th, 2010
 *
 */

module syntax.module_declaration_unit;

import lex.token;
import lex.lexer;
import logger;

/*

   ModuleDecl => ( . Identifier )+ ;

*/

class ModuleDeclarationUnit {
private:
	char[] cur_string;
	Logger _logger;
	Lexer _lexer;
	int _state = 0;

	Token _last;

	static const char[] _common_error_msg = "The module declaration is not formed correctly.";
	static const char[][] _common_error_usages = ["module package.file;"];

public:
	this(Lexer lexer, Logger logger) {
		_logger = logger;
		_lexer = lexer;
	}

	char[] parse() {
		Token token;
		for (;;) {
			token = _lexer.pop();
			if (token.type == 0 || !tokenFound(token)) {
				break;
			}
			if (_logger.errors) {
				return null;
			}
			_last = token;
		}
		return cur_string;
	}

	bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Dot:
				if (_state == 0) {
					_logger.error(_lexer, current, _common_error_msg,
					              "You may not start a declaration with a dot.",
					              _common_error_usages);
					return true;
				}
				else if (_state == 1) {
					_logger.error(_lexer, current, _common_error_msg,
					              "There are a few too many dots in a row. Did you mean to have only one?",
					              _common_error_usages);
					return true;
				}

				_state = 1;

				if (cur_string.length > 0 && cur_string[$-1] == '.') {

					// Error: We found two dots, probably left behind after an edit.
					_logger.error(_lexer, current, _common_error_msg,
					              "There are a few too many dots in a row. Did you mean to have only one?",
					              _common_error_usages);
					return true;
				}
				else {
					cur_string ~= ".";
				}
				break;
			case Token.Type.Semicolon:

				if (_state == 0) {
					// module ;
					// Error: No module name given
					_logger.error(_lexer, current, _common_error_msg,
						"You forgot to name the module.",
						_common_error_usages);
					return true;
				}
				else if (_state == 1) {
					// module foo. ;
					// Error: Ended on a dot.
					_logger.error(_lexer, current, _common_error_msg,
						"You ended the module name with a dot. Perhaps you forgot to delete this dot?",
						_common_error_usages);
					return true;
				}

				// End of declaration
				return false;

			case Token.Type.Identifier:

				if (_state == 2) {
					// Error: Found an identifier next to an identifier... unintentional space?
					_logger.error(_lexer, current, _common_error_msg,
						"You cannot put a space in a module name. Did you mean to use an underscore?",
						_common_error_usages);
					return true;
				}

				_state = 2;

				if (cur_string.length > 0 && cur_string[$-1] != '.') {

					// Error: Found an identifier and then another identifier. Probably
					// due to an editing mistake.
					_logger.error(_lexer, current, _common_error_msg,
							"Did you mean to place a '.' between the two names?",
							_common_error_usages);
					return true;
				}
				else {

					// Add the package or module name to the overall value.
					cur_string ~= current.string;

				}

				break;

			// Common erroneous tokens
			case Token.Type.Slice:
				// Error: Found .. when we expected just one dot.
				_logger.error(_lexer, current, _common_error_msg,
					"You placed two dots, did you mean to only have one?",
					_common_error_usages);
				return true;

			case Token.Type.Variadic:
				// Error: Found ... when we expected just one dot.
				_logger.error(_lexer, current, _common_error_msg,
					"You placed three dots, did you mean to only have one?",
					_common_error_usages);
				return true;

			case Token.Type.IntegerLiteral:
			case Token.Type.FloatingPointLiteral:
				_logger.error(_lexer, current, _common_error_msg,
					"Identifiers, such as module names, cannot start with a number.",
					_common_error_usages);
				return true;
			default:

				// Error: Found some illegal token. Probably due to lack of semicolon.
				_logger.errorAtEnd(_lexer, _last, _common_error_msg,
					"You probably forgot a semicolon.",
					_common_error_usages);
				return true;
		}
		return true;
	}
}
