/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.classdeclunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.declarationunit;
import syntax.classbodyunit;

import tango.io.Stdout;

class ClassDeclUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			// The start of the body
			case Token.Type.LeftCurly:
				auto tree = expand!(ClassBodyUnit)();

				// Done.
				return false;

			// Look for a template parameter list
			case Token.Type.LeftParen:
				if (cur_string == "") {
					// Error: No name?
					// TODO:
				}
				if (this.state >= 1) {
					// Error: Already have base class list or template parameters
					// TODO:
				}
				this.state = 1;

				// TODO: expand out parameter list				
				break;

			// Look for inherited classes
			case Token.Type.Colon:
				if (cur_string == "") {
					// Error: No name?
					// TODO:
				}
				if (this.state >= 2) {
					// Error: Already have base class list
					// TODO:
				}
				this.state = 2;

				// TODO: expand out base class list
				break;

			// Name
			case Token.Type.Identifier:
				if (cur_string != "") {
					// Error: Two names?
					// TODO:
				}
				Stdout("Class: ")(current.string).newline;
				cur_string = current.string;
				break;

			default:
				// Error: Unrecognized foo.
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
