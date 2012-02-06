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
import syntax.initializerunit;
import syntax.functionbodyunit;

import tango.io.Stdout;

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
						// Named Type
					case Token.Type.Identifier:

						// We have a basic type... look for Declarator
						Stdout("DECLARATOR").newline;
						auto tree = expand!(DeclaratorUnit)();
						this.state = 1;
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
						Stdout("done").newline;
						return false;
					case Token.Type.Comma:
						// Look for another declarator
						Stdout("DECLARATOR").newline;
						auto tree = expand!(DeclaratorUnit)();
						break;

					case Token.Type.Assign:
						// Initializer
						auto tree = expand!(InitializerUnit)();
						this.state = 4;
						break;
					case Token.Type.LeftCurly:
					case Token.Type.In:
					case Token.Type.Out:
					case Token.Type.Body:
						// It could be a function body
						lexer.push(current);
						auto tree = expand!(FunctionBodyUnit)();
						return false;

					default:
						// Bad
						break;
				}
				break;

			case 4:
				switch(current.type) {
					case Token.Type.Comma:
						// Initializer list
						auto tree = expand!(DeclaratorUnit)();
						state = 1;
						break;

					case Token.Type.Assign:
						// Bad
						break;

					case Token.Type.Semicolon:
						// Done
						Stdout("done").newline;
						return false;
				}
				break;

			default:
				break;
		}
		return true;
	}
}
