/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.declaratorunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.declaratorsuffixunit;
import syntax.declaratortypeunit;

class DeclaratorUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (state) {
			case 0:
				switch (current.type) {

					// Name
					case Token.Type.Identifier:
						this.state = 1;
						break;

					// Nested Declarators
					case Token.Type.LeftParen:
						auto tree = expand!(DeclaratorUnit)();
						this.state = 3;
						break;
	
					// More complicated Declarator, push off to DeclaratorType
					default:
						lexer.push(current);
						auto tree = expand!(DeclaratorTypeUnit)();
						this.state = 2;
						break;
				}
				break;
			case 1:
				lexer.push(current);
				switch (current.type) {
					// This hints to the next part being a DeclaratorSuffix
					case Token.Type.LeftBracket:
					case Token.Type.LeftParen:
						auto tree = expand!(DeclaratorSuffixUnit)();
						break;
					default:
						// Done
						return false;
				}
				break;

			// After DeclaratorTypeUnit, look for the signs of another Declarator
			case 2:
				lexer.push(current);
				switch(current.type) {
					// We have another declarator
					case Token.Type.Identifier:
					case Token.Type.LeftParen:
						auto tree = expand!(DeclaratorUnit)();
						break;

					default:
						// done
						break;
				}
				return false;

			// We have a nested declarator in play... look for a right
			// parenthesis.
			case 3:
				switch(current.type) {
					case Token.Type.RightParen:
						// Good
						this.state = 1;
						break;

					default:
						// Bad
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
