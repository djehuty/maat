/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.classbodyunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.declarationunit;

class ClassBodyUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			// We are always looking for the end of the body.
			case Token.Type.RightCurly:
				// Done.
				return false;

			// A new keyword will set up an allocator.
			case Token.Type.New:
				// TODO:
				break;

			// Ditto for a delete token for deallocator.
			case Token.Type.Delete:
				// TODO:
				break;

			// Otherwise, it must be some Declarator
			default:
				lexer.push(current);
				auto tree = expand!(DeclarationUnit)();
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
