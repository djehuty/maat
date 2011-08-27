/*
 * declarationunit.d
 *
 */

module syntax.declarationunit;

import syntax.parseunit;
import lex.lexer;
import lex.token;

import syntax.nodes;
import syntax.moduledeclunit;
import syntax.importdeclunit;
import syntax.staticunit;
import syntax.versionunit;
import syntax.unittestunit;
import syntax.debugunit;
import syntax.declarationunit;
import syntax.typedeclarationunit;
import syntax.enumdeclunit;
import syntax.aggregatedeclunit;
import syntax.classdeclunit;
import syntax.interfacedeclunit;
import syntax.constructorunit;
import syntax.destructorunit;
import syntax.pragmastmtunit;

class DeclarationUnit : ParseUnit {
protected:

	override bool tokenFound(Token current) {

		// This parsing unit searches for declarations.

		switch (current.type) {

			// Module Declaration
			case Token.Type.Module:
				
				// Error: The module declaration is found, 
				// but it is not at the root of the parse tree.
				error("Module declaration should be on one of the first lines of the file.");
				break;

			// Attribute Specifier
			case Token.Type.Synchronized:
			case Token.Type.Deprecated:
			case Token.Type.Final:
			case Token.Type.Override:
			case Token.Type.Auto:
			case Token.Type.Scope:
			case Token.Type.Private:
			case Token.Type.Public:
			case Token.Type.Protected:
			case Token.Type.Export:
			case Token.Type.Extern:
			case Token.Type.Align:
				break;

			case Token.Type.Pragma:
				auto tree = expand!(PragmaStmtUnit)();
				break;

			// Static
			case Token.Type.Static:
				auto tree = expand!(StaticUnit)();
				break;

			// Import Declaration
			case Token.Type.Import:
				auto tree = expand!(ImportDeclUnit)();
				break;

			// Enum Declaration
			case Token.Type.Enum:
				auto tree = expand!(EnumDeclUnit)();
				break;

			// Template Declaration
			case Token.Type.Template:
				break;

			// Mixin Declaration
			case Token.Type.Mixin:
				break;

			// Class Declaration
			case Token.Type.Class:
				auto tree = expand!(ClassDeclUnit)();
				break;

			// Interface Declaration
			case Token.Type.Interface:
				auto tree = expand!(InterfaceDeclUnit)();
				break;

			// Aggregate Declaration
			case Token.Type.Struct:
			case Token.Type.Union:
				auto tree = expand!(AggregateDeclUnit)();
				break;

			// Constructor Declaration
			case Token.Type.This:
				auto tree = expand!(ConstructorUnit)();
				break;

			// Destructor Declaration
			case Token.Type.Cat:
				auto tree = expand!(DestructorUnit)();
				break;

			// Version Block
			case Token.Type.Version:
				auto tree = expand!(VersionUnit)();
				break;

			// Debug Block
			case Token.Type.Debug:
				auto tree = expand!(DebugUnit)();
				break;

			// Unittest Block
			case Token.Type.Unittest:
				auto tree = expand!(UnittestUnit)();
				break;

			// Typedef Declaration
			case Token.Type.Typedef:
				break;

			// Alias Declaration
			case Token.Type.Alias:
				break;

			// A random semicolon, can't hurt
			case Token.Type.Semicolon:
				break;

			// If we cannot figure it out, it must be a Type Declaration
			default:
				lexer.push(current);
				auto tree = expand!(TypeDeclarationUnit)();
				break;
		}
		return false;
	}
}
