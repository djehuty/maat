/*
 * parameterunit.d
 *
 * This module parses individual parameters.
 *
 */

module syntax.parameterunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.parameterlistunit;
import syntax.functionbodyunit;
import syntax.declaratorunit;
import syntax.declaratormiddleunit;
import syntax.basictypeunit;
import syntax.assignexprunit;

import tango.io.Stdout;

/*

	Parameter => ( ref | out | in | lazy )? BasicType Declarator ( = AssignExpr )?
			   | ( ref | out | in | lazy )? BasicType ( ... )?
			   | ( ref | out | in | lazy )? BasicType DeclaratorMiddle ( ... )?

	(can start with one of these: {* [ ( delegate function})
	Declarator => ( BasicTypeSuffix )? ( Declarator ) ( DeclaratorSuffix )*
	            | ( BasicTypeSuffix )? Identifier ( DeclaratorSuffix )*

	Declarators HAVE identifiers... DeclaratorMiddles... Don't
	Parameters can have one, the other, or none (eff)

	(must start with one of these: {* [ ( delegate function})
	DeclaratorMiddle => ( BasicTypeSuffix )? ( ( DeclaratorMiddle ) )? ( DeclaratorSuffix )*
	Examples: ref void[], in int, out int (no declarator... technically possible in a parameter)

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

class ParameterUnit : ParseUnit {
	enum States {
		Start,
		FoundPassBySpecifier,
		FoundBasicType,
		FoundDeclaratorMiddle,
	}

	override bool tokenFound(Token current) {
		switch (current.type) {

			// Default Initializers
			case Token.Type.Assign:
				if (this.state != States.FoundDeclaratorMiddle) {
					// Error: We don't have a declarator!
					// TODO:
				}

				// TODO:
				auto tree = expand!(AssignExprUnit)();

				// Done.
				return false;

			// Figure out the specifier.
			case Token.Type.In:
			case Token.Type.Out:
			case Token.Type.Ref:
			case Token.Type.Lazy:
				if (this.state != States.Start) {
					// Error: Already have an in, out, ref, or lazy specifier.
					// TODO:
				}

				// Specifier.

				state = States.FoundPassBySpecifier;

				// Fall through to hit the declarator call

				goto default;

			case Token.Type.Variadic:
				if (state != States.FoundDeclaratorMiddle) {
					// Error:
					// TODO:
				}

				// Done
				return false;

			case Token.Type.LeftParen:
			case Token.Type.Delegate:
			case Token.Type.Function:
			case Token.Type.Mul:
			case Token.Type.LeftBracket:
				if (state != States.FoundBasicType) {
					// Error:
					// TODO:
				}

				lexer.push(current);

				auto tree = expand!(DeclaratorMiddleUnit)();
				state = States.FoundDeclaratorMiddle;
				break;

			default:
				lexer.push(current);

				if (this.state == States.FoundBasicType) {
					// Could be a declarator then.
					auto tree = expand!(DeclaratorMiddleUnit)();
					this.state = States.FoundDeclaratorMiddle;
				}
				else if (this.state == States.Start ||
						this.state == States.FoundPassBySpecifier) {
					// Hopefully this is a BasicType 
					auto tree = expand!(BasicTypeUnit)();
					this.state = States.FoundBasicType;
				}
				else if (this.state == States.FoundDeclaratorMiddle) {
					// Done
					return false;
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
