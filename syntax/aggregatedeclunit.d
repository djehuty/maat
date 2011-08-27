/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.aggregatedeclunit;

import syntax.parseunit;

import lex.token;
import syntax.nodes;

import syntax.aggregatebodyunit;

class AggregateDeclUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {

			// We have found the name
			case DToken.Identifier:
				if (cur_string != "") {
					// Error: Two names?
				}
				Console.putln("Struct: ", current.value);
				cur_string = current.value.toString();
				break;

			// We have found the left brace, so parse the body
			case DToken.LeftCurly:
				auto tree = expand!(AggregateBodyUnit)();
				// Done.
				return false;

			case DToken.Semicolon:
				if (cur_string == "") {
					// Error: No name?
				}
				// Done.
				return false;

			default:
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
