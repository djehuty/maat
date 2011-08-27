/*
 * staticunit.d
 *
 */

module syntax.staticunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.staticifunit;
import syntax.staticassertunit;

class StaticUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.If:
				// Static If (Compile-time condition)
				// static if ...
				auto tree = expand!(StaticIfUnit)();
				break;
			case Token.Type.Assert:
				// Static Assert (Compile-time assert)

				// static assert ...
				auto tree = expand!(StaticAssertUnit)();
				break;
			case Token.Type.This:
				// Static Constructor

				// static this ...
				break;
			case Token.Type.Cat:
				// Static Destructor

				// static ~ this ...
				break;
			default:
				// Attribute Specifier
				// static Type
				break;
		}
		return true;
	}
}
