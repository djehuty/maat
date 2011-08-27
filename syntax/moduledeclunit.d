/*
 * moduledeclunit.d
 *
 * This module parses out the 'identifier.foo.bar' stuff out of a module
 * or import statement.
 *
 * Author: Dave Wilkinson
 * Originated: February 6th, 2010
 *
 */

module syntax.moduledeclunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import tango.io.Stdout;

class ModuleDeclUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Dot:
				if (state == 0) {
					error(_common_error_msg,
						"You may not start a declaration with a dot.",
						_common_error_usages);
					break;
				}
				else if (state == 1) {
					error(_common_error_msg,
						"There are a few too many dots in a row. Did you mean to have only one?",
						_common_error_usages);
					break;
				}

				state = 1;

				if (cur_string.length > 0 && cur_string[$-1] == '.') {

					// Error: We found two dots, probably left behind after an edit.
					error(_common_error_msg,
							"There are a few too many dots in a row. Did you mean to have only one?",
							_common_error_usages);

				}
				else {
					cur_string ~= ".";
				}
				break;
			case Token.Type.Semicolon:

				Stdout("Module: ")(cur_string).newline;
				// End of declaration
				return false;

			case Token.Type.Identifier:

				if (state == 2) {
					// Error: Found an identifier next to an identifier... unintentional space?
					error(_common_error_msg,
						"You cannot put a space in a module name. Did you mean to use an underscore?",
						_common_error_usages);
					break;
				}

				state = 2;

				if (cur_string.length > 0 && cur_string[$-1] != '.') {

					// Error: Found an identifier and then another identifier. Probably
					// due to an editing mistake.
					error(_common_error_msg,
							"Did you mean to place a '.' between the two names?",
							_common_error_usages);

				}
				else {

					// Add the package or module name to the overall value.
					cur_string ~= current.string;

				}

				break;

			// Common erroneous tokens
			case Token.Type.Slice:
				// Error: Found .. when we expected just one dot.
				error(_common_error_msg,
					"You placed two dots, did you mean to only have one?",
					_common_error_usages);
				break;

			case Token.Type.Variadic:
				// Error: Found ... when we expected just one dot.
				error(_common_error_msg,
					"You placed three dots, did you mean to only have one?",
					_common_error_usages);
				break;

			case Token.Type.IntegerLiteral:
			case Token.Type.FloatingPointLiteral:
				error(_common_error_msg,
					"Identifiers, such as module names, cannot start with a number.",
					_common_error_usages);
				break;
			default:

				// Error: Found some illegal token. Probably due to lack of semicolon.
				errorAtPrevious(_common_error_msg,
					"You probably forgot a semicolon.",
					_common_error_usages);
				break;
		}
		return true;
	}
protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "The module declaration is not formed correctly.";
	static const char[][] _common_error_usages = ["module package.file;"];
}
