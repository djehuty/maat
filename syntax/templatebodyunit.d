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
			case DToken.RightCurly:
				// Done.
				return false;

			// We cannot have allocators in templates!
			case DToken.New:
				// Error: No allocators allowed.
				// TODO:
				break;

			// Ditto for a delete token for deallocator.
			case DToken.Delete:
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
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
