/*
 * typedeclarationunit.d
 *
 */

module syntax.typedeclarationunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.staticunit;
import syntax.declaratorunit;

class TypeDeclarationUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch(this.state) {

			// Looking for a basic type or identifier
			case 0:
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
						// We have a basic type... look for Declarator
						auto tree = expand!(DeclaratorUnit)();
						this.state = 1;
						break;

					case Token.Type.Identifier:
						// Named Type
						break;

					case Token.Type.Typeof:
						// TypeOfExpression
						// TODO: this
						break;

					// Invalid token for this state
					case Token.Type.Assign:
						break;

					// Invalid token for this state
					case Token.Type.Semicolon:
						break;

					default:

						// We will pass this off to a Declarator
						auto tree = expand!(DeclaratorUnit)();
						this.state = 1;
						break;
				}

			// We have found a basic type and are looking for either an initializer
			// or another type declaration. We could also have a function body
			// for function literals.
			case 1:
				switch(current.type) {
					case Token.Type.Semicolon:
						// Done
						return false;
					case Token.Type.Comma:
						// XXX: Dunno
						return false;
					case Token.Type.Assign:
						// Initializer
//						auto tree = expand!(InitializerUnit)();
						this.state = 4;
						break;
					default:
						// It could be a function body
//						auto tree = expand!(FunctionBodyUnit)();
						return false;
				}
				break;

			default:
				break;
		}
		return true;
	}
}
