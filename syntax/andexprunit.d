/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.andexprunit;

import syntax.parseunit;

import lex.token;
import syntax.nodes;

import syntax.cmpexprunit;

class AndExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.And:
				if (this.state == 1) {
					Console.putln("AND");
					this.state = 0;
					break;
				}

				// Fall through
				goto default;

			default:
				lexer.push(current);
				if (this.state == 1) {
					// Done.
					return false;
				}
				auto tree = expand!(CmpExprUnit)();
				this.state = 1;
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
