/*
 * declaration_unit.d
 *
 */

module syntax.declaration_unit;

import syntax.pragma_statement_unit;
import syntax.debug_statement_unit;
import syntax.static_statement_unit;
import syntax.type_declaration_unit;
import syntax.class_declaration_unit;
import syntax.interface_declaration_unit;
import syntax.enum_declaration_unit;
import syntax.aggregate_declaration_unit;
import syntax.import_declaration_unit;
import syntax.constructor_declaration_unit;
import syntax.destructor_declaration_unit;

import lex.lexer;
import lex.token;

import logger;

import ast.declaration_node;

class DeclarationUnit {
private:
	Lexer  _lexer;
	Logger _logger;

public:
	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}

	DeclarationNode parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

		return new DeclarationNode();
	}

	bool tokenFound(Token token) {
		switch (token.type) {
			case Token.Type.EOF:
				return false;

			case Token.Type.Comment:
				return true;

			// Module Declaration
			case Token.Type.Module:
				
				// Error: The module declaration is found, 
				// but it is not at the root of the parse tree.
				_logger.error(_lexer, token, "Module declaration should be on one of the first lines of the file.");
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
				auto stmt = (new PragmaStatementUnit(_lexer, _logger)).parse;
				break;

			// Static
			case Token.Type.Static:
				auto stmt = (new StaticStatementUnit(_lexer, _logger)).parse;
				break;

			// Import Declaration
			case Token.Type.Import:
				auto decl = (new ImportDeclarationUnit(_lexer, _logger)).parse;
				break;

			// Enum Declaration
			case Token.Type.Enum:
				auto decl = (new EnumDeclarationUnit(_lexer, _logger)).parse;
				break;

			// Template Declaration
			case Token.Type.Template:
				break;

			// Mixin Declaration
			case Token.Type.Mixin:
				break;

			// Class Declaration
			case Token.Type.Class:
				auto decl = (new ClassDeclarationUnit(_lexer, _logger)).parse;
				break;

			// Interface Declaration
			case Token.Type.Interface:
				auto decl = (new InterfaceDeclarationUnit(_lexer, _logger)).parse;
				break;

			// Aggregate Declaration
			case Token.Type.Struct:
			case Token.Type.Union:
				auto decl = (new AggregateDeclarationUnit(_lexer, _logger)).parse;
				break;

			// Constructor Declaration
			case Token.Type.This:
				auto decl = (new ConstructorDeclarationUnit(_lexer, _logger)).parse;
				break;

			// Destructor Declaration
			case Token.Type.Cat:
				auto decl = (new DestructorDeclarationUnit(_lexer, _logger)).parse;
				break;

			// Version Block
			case Token.Type.Version:
//				auto tree = expand!(VersionUnit)();
				break;

			// Debug Block
			case Token.Type.Debug:
				auto stmt = (new DebugStatementUnit(_lexer, _logger)).parse;
				break;

			// Unittest Block
			case Token.Type.Unittest:
//				auto tree = expand!(UnittestUnit)();
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
				_lexer.push(token);
				auto decl = (new TypeDeclarationUnit(_lexer, _logger)).parse;
				break;
		}
		return false;
	}
}
