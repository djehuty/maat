/*
 * staticunit.d
 *
 */

module parsing.d.staticunit;

import parsing.parseunit;
import parsing.token;

import parsing.d.tokens;
import parsing.d.nodes;

import parsing.d.staticifunit;
import parsing.d.staticassertunit;

import djehuty;

class StaticUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.If:
				// Static If (Compile-time condition)
				// static if ...
				auto tree = expand!(StaticIfUnit)();
				break;
			case DToken.Assert:
				// Static Assert (Compile-time assert)

				// static assert ...
				auto tree = expand!(StaticAssertUnit)();
				break;
			case DToken.This:
				// Static Constructor

				// static this ...
				break;
			case DToken.Cat:
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
