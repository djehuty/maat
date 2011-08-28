/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.parameterlistunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.parameterunit;
import syntax.functionbodyunit;
import syntax.declaratorunit;

/*

	ParameterList => Parameter , ParameterList
	               | Parameter )
	               | )

*/

class ParameterListUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {

			case Token.Type.RightParen:
				// Done.
				return false;

			case Token.Type.Variadic:
				if (this.state == 2) {
					// Error: Have two variadics?!
					// TODO: One too many variadics.
				}
				// We have a variadic!
				this.state = 2;
				break;

			case Token.Type.Comma:
				if (this.state == 0) {
					// Error: Expected a parameter!
					// TODO: Probably accidently removed a parameter without removing the comma.
				}

				// Get Parameter
				this.state = 0;
				break;

			default:
				if (this.state == 0) {
					// Look for a parameter
					lexer.push(current);
					auto tree = expand!(ParameterUnit)();
					this.state = 1;
				}
				else if (this.state == 2) {
					// Error: Parameter after variadic?
					// TODO: Forgot comma.
				}
				else {
					// Error: otherwise
					// TODO:
				}

				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
