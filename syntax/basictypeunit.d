/*
 * typedeclarationunit.d
 *
 */

module syntax.basictypeunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.staticunit;
import syntax.declaratorunit;
import syntax.identifierlistunit;

/*

	BasicType => bool
	           | byte
	           | ubyte
	           | short
	           | ushort
	           | int
	           | uint
	           | long
	           | ulong
	           | char
	           | wchar
	           | dchar
	           | float
	           | double
	           | real
	           | ifloat
	           | idouble
	           | ireal
	           | cfloat
	           | cdouble
	           | creal
	           | void
	           | . IdentifierList
	           | IdentifierList
	           | Typeof ( . IdentifierList )?

	IdentifierList => Identifier . IdentifierList
	                | Identifier
	                | TemplateInstance . IdentifierList
	                | TemplateInstance

*/

class BasicTypeUnit : ParseUnit {
	override bool tokenFound(Token current) {

		switch (current.type) {
			case Token.Type.Bool:
			case Token.Type.Byte:
			case Token.Type.Ubyte:
			case Token.Type.Short:
			case Token.Type.Ushort:
			case Token.Type.Int:
			case Token.Type.Uint:
			case Token.Type.Long:
			case Token.Type.Ulong:
			case Token.Type.Char:
			case Token.Type.Wchar:
			case Token.Type.Dchar:
			case Token.Type.Float:
			case Token.Type.Double:
			case Token.Type.Real:
			case Token.Type.Ifloat:
			case Token.Type.Idouble:
			case Token.Type.Ireal:
			case Token.Type.Cfloat:
			case Token.Type.Cdouble:
			case Token.Type.Creal:
			case Token.Type.Void:
				// We have a basic type
				// Done.
				return false;

			case Token.Type.Identifier:
				// Named Type, could be a scoped list
				lexer.push(current);
				auto tree = expand!(IdentifierListUnit)();
				return false;

			// Scope Operator
			case Token.Type.Dot:
				auto tree = expand!(IdentifierListUnit)();
				break;

			case Token.Type.Typeof:
				// TypeOfExpression
				// TODO: this
				break;

			default:
				// Error:
				// TODO:
				break;
		}
		return true;
	}
}
