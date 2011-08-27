/*
 * addexprunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.addexprunit;

import lex.token;

import syntax.parseunit;

import syntax.nodes;

import syntax.mulexprunit;

class AddExprUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.Add:
			case DToken.Sub:
			case DToken.Cat:
				if (this.state == 1) {
					Console.putln("ADD");
					this.state = 0;
					break;
				}

				// Fall through

			default:
				lexer.push(current);
				if (this.state == 1) {
					// Done.
					return false;
				}
				auto tree = expand!(MulExprUnit)();
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
