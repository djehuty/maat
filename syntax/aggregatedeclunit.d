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
			case Token.Type.Identifier:
				if (cur_string != "") {
					// Error: Two names?
				}
				cur_string = current.string;
				break;

			// We have found the left brace, so parse the body
			case Token.Type.LeftCurly:
				auto tree = expand!(AggregateBodyUnit)();
				// Done.
				return false;

			case Token.Type.Semicolon:
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
