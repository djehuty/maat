/*
 * import_declaration_unit.d
 *
 */

module syntax.import_declaration_unit;

import lex.lexer;
import lex.token;
import logger;

import tango.io.Stdout;

/*

	ImportDecl => ( static )? import ImportList ;

	ImportList => ( Identifier . )+ ( : ImportBindList )? , ImportList
	            | ( Identifier . )+ ( : ImportBindList )?

	ImportBindList => Identifier ( = Identifier )? , ImportBindList
	                | Identifier ( = Identifier )?

*/

class ImportDeclarationUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

	char[] _cur_string;

	Token  _last;

	char[] cur_string = "";

	static const char[] _common_error_msg = "The import declaration is not formed correctly.";
	static const char[][] _common_error_usages = [
		"import package.file;",
		"import MyAlias = package.file;",
		"import MyFoo = package.file : Foo;"
	];

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
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

	bool tokenFound(Token token) {
		switch (token.type) {
			case Token.Type.Dot:
				if (_cur_string.length > 0 && _cur_string[$-1] == '.') {

					// Error: We found two dots, probably left behind after an edit.
					_logger.error(_lexer, token, _common_error_msg,
							"There are a few too many dots in a row. Did you mean to have only one?",
							_common_error_usages);

				}
				else {
					_cur_string ~= ".";
				}
				break;

			case Token.Type.Semicolon:
				// End of declaration
				Stdout("Import: ")(_cur_string).newline;
				return false;

			case Token.Type.Identifier:
				if (_cur_string.length > 0 && _cur_string[$-1] != '.') {

					// Error: Found an identifier and then another identifier. Probably
					// due to an editing mistake.
					_logger.error(_lexer, token, _common_error_msg,
							"Did you mean to place a '.' between the two names?",
							_common_error_usages);

				}
				else {
					// Add the package or module name to the overall value.
					_cur_string ~= token.string;
				}

				break;
			case Token.Type.Slice:
				// Error: Found .. when we expected just one dot.
				_logger.error(_lexer, token, _common_error_msg,
					"You placed two dots, did you mean to only have one?",
					_common_error_usages);
				break;

			case Token.Type.Variadic:
				// Error: Found ... when we expected just one dot.
				_logger.error(_lexer, token, _common_error_msg,
					"You placed three dots, did you mean to only have one?",
					_common_error_usages);
				break;
			default:

				// Error: Found some illegal token. Probably due to lack of semicolon.
				_logger.errorAtEnd(_lexer, _last, _common_error_msg,
					"You probably forgot a semicolon.",
					_common_error_usages);
				break;
		}
		return true;
	}
}
