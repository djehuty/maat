/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.enumdeclunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.typeunit;
import syntax.enumbodyunit;

class EnumDeclUnit : ParseUnit {
	override bool tokenFound(Token current) {
		// Looking for a name, or a colon for a type, or a curly
		// braces for the enum body
		switch (current.type) {
			case Token.Type.Identifier:
				// The name of the enum
				if (this.state >= 1) {
					// We are already passed the name stage.
					// XXX: error
				}
				this.state = 1;
				cur_string = current.string;
				break;
			case Token.Type.Colon:
				// The type of the enum
				if (this.state >= 2) {
					// Already passed the type stage.
					// XXX: error
				}
				this.state = 2;
				auto tree = expand!(TypeUnit)();
				break;
			case Token.Type.Semicolon:
				if (this.state == 0) {
					// Need some kind of information about the enum.
					error(_common_error_msg,
							"Without a name, the linker will not know what it should be linking to.",
							["enum FooBar;", "enum FooBar : uint;"]);
					return false;
				}
				// Done.
				return false;
			case Token.Type.LeftCurly:
				// We are going into the body of the enum
				auto tree = expand!(EnumBodyUnit)();
				// Done.
				return false;
			default:
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "Enum declaration is invalid.";
	static const char[][] _common_error_usages = null;
}
