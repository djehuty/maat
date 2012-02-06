/*
 * declaratorunit.d
 *
 * This module parses declarators.
 *
 */

module syntax.declaratormiddleunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.declaratorsuffixunit;
import syntax.declaratortypeunit;
import syntax.basictypesuffixunit;

import tango.io.Stdout;
/*

	Declarator => ( BasicTypeSuffix )? ( Declarator ) ( DeclaratorSuffix )*
	            | ( BasicTypeSuffix )? Identifier ( DeclaratorSuffix )*

	(must start with one of these: {* [ ( delegate function})
	DeclaratorMiddle => Declarator
	                  | ( BasicTypeSuffix )* ( ( DeclaratorMiddle ) )? ( DeclaratorSuffix )*

	DeclaratorSuffix => [ ]
	                  | [ Expression ]
	                  | [ Type ]
	                  | ( ( TemplateParameterList )? ( ParameterList

	BasicTypeSuffix => *
	                 | [ ]
	                 | [ Expression ]
					 | [ Expression .. Expression ]
	                 | [ Type ]
	                 | delegate ( ParameterList
	                 | function ( ParameterList

	Must disambiguate between BasicTypeSuffix and DeclaratorSuffix
	If it is a BasicTypeSuffix, disambiguate between Declarator and
	DeclaratorMiddle by looking for a following Identifier or (
	If it is a ( then it could still be either a Declarator or DeclaratorMiddle
	until it finds an Identifier.

	The only difference is that a Declarator can have an initial value.
	That is, = is only allowed (and ... disallowed) when a Declarator is
	found over a DeclaratorMiddle.

*/

class DeclaratorMiddleUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (state) {
			case 0:
				switch (current.type) {
					case Token.Type.LeftBracket:
					case Token.Type.Delegate:
					case Token.Type.Function:
					case Token.Type.Mul:
						lexer.push(current);
						auto tree = expand!(BasicTypeSuffixUnit)();
						break;

					case Token.Type.LeftParen:
						// Recursive Declarator
						auto tree = expand!(DeclaratorMiddleUnit)();
						state = 2;
						break;

					case Token.Type.Identifier:
						state = 3;
						Stdout("Name: ")(current.string).newline;
						break;

					default:
						// Fine.
						lexer.push(current);
						return false;
				}
				break;

			// Found BasicTypeSuffix, Look for either a recursive Declarator
			// Identifier or DeclaratorSuffix
			case 1:
				switch (current.type) {
					case Token.Type.LeftParen:
						// Recursive Declarator
						auto tree = expand!(DeclaratorMiddleUnit)();
						state = 2;
						break;
					case Token.Type.Identifier:
						state = 3;
						Stdout("Name: ")(current.string).newline;
						break;
					default:
						// OK.
						lexer.push(current);
						state = 3;
						break;
				}
				break;

			// After a recursive Declarator, look for the end parenthesis
			case 2:
				switch(current.type) {
					case Token.Type.RightParen:
						state = 3;
						break;
					case Token.Type.Identifier:
					default:
						// Bad
						break;
				}
				break;

			// Found (Declarator) or Identifier... look for Declarator Suffix (if exists)
			case 3:
				switch(current.type) {
					case Token.Type.LeftBracket:
					case Token.Type.Mul:
					case Token.Type.LeftParen:
						lexer.push(current);
						auto tree = expand!(DeclaratorSuffixUnit)();
						break;

					default:
						// Fine.
						lexer.push(current);
				}
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
