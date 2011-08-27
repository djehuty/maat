/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.templatebodyunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.declarationunit;

class TemplateBodyUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			// We are always looking for the end of the body.
			case Token.Type.RightCurly:
				// Done.
				return false;

			// We cannot have allocators in templates!
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
