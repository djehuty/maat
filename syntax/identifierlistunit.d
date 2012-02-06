/*
 * typedeclarationunit.d
 *
 */

module syntax.identifierlistunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

/*

	IdentifierList => Identifier ( . IdentifierList )?

*/
class IdentifierListUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Identifier:
				if (state == 1) {
					// OK
					lexer.push(current);
					return false;
				}

				state = 1;
				break;
			case Token.Type.Dot:
				// OK
				if (state != 1) {
					// Bad
				}

				state = 0;
				break;

			default:
				lexer.push(current);
				return false;
		}
		return true;
	}
}
