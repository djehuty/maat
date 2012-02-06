/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.declaratorsuffixunit;

import syntax.parseunit;

import lex.token;

import syntax.nodes;

import syntax.expressionunit;
import syntax.parameterlistunit;

/*

	DeclaratorSuffix => [ ]
	                  | [ Expression ]
	                  | [ Type ]
	                  | ( TemplateParameterList )? ( ParameterList

*/

class DeclaratorSuffixUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (this.state) {
			case 0:
				// Looking for ( or [
				// Types which have () or [] after them
				switch (current.type) {
					case Token.Type.LeftParen:
						this.state = 1;
						break;
					case Token.Type.LeftBracket:
						this.state = 2;
						break;
					default:
						break;
				}
				break;

			case 1:
				// We have found a ( so we are searching for
				// a right parenthesis
				switch (current.type) {
					case Token.Type.RightParen:
						// Done
						break;
					default:
						// This is a parameter list
						// XXX:
						lexer.push(current);
						auto tree = expand!(ParameterListUnit)();
						break;
				}
				return false;

			case 2:
				// We have found a [ so we are searching for
				// a right bracket.
				switch (current.type) {
					case Token.Type.RightBracket:
						// Done
						return false;

					case Token.Type.Dot:
						break;

					case Token.Type.Identifier:
						break;

					default:
						// We should assume it is an expression
						lexer.push(current);
						auto tree = expand!(ExpressionUnit)();
						break;
				}
				break;
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
