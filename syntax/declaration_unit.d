/*
 * declaration_unit.d
 *
 */

module syntax.declaration_unit;

import syntax.pragma_statement_unit;
import syntax.attribute_unit;
import syntax.debug_statement_unit;
import syntax.static_disambiguation_unit;
import syntax.static_if_statement_unit;
import syntax.static_assert_statement_unit;
import syntax.type_declaration_unit;
import syntax.class_declaration_unit;
import syntax.interface_declaration_unit;
import syntax.enum_declaration_unit;
import syntax.aggregate_declaration_unit;
import syntax.import_declaration_unit;
import syntax.constructor_declaration_unit;
import syntax.destructor_declaration_unit;
import syntax.version_statement_unit;

import ast.declaration_node;
import ast.import_declaration_node;
import ast.type_declaration_node;

import lex.lexer;
import lex.token;

import logger;

class DeclarationUnit {
private:
	Lexer  _lexer;
	Logger _logger;

  DeclarationNode _declaration;

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

    return _declaration;
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

			case Token.Type.Pragma:
				auto stmt = (new PragmaStatementUnit(_lexer, _logger)).parse;
				break;

			// Static
			case Token.Type.Static:
        auto staticVariant = (new StaticDisambiguationUnit(_lexer, _logger)).parse;

        if (staticVariant == StaticDisambiguationUnit.StaticVariant.StaticIf) {
//          _declaration = (new StaticIfStatementUnit(_lexer, _logger)).parse;
        }
        else if (staticVariant == StaticDisambiguationUnit.StaticVariant.StaticAssert) {
          // Get rid of assert token
          _lexer.pop();

          // Get declaration that follows
          _declaration = (new StaticAssertStatementUnit(_lexer, _logger)).parse;
        }
        else if (staticVariant == StaticDisambiguationUnit.StaticVariant.StaticConstructor) {
//          _declaration = (new StaticConstructorStatementUnit(_lexer, _logger)).parse;
        }
        else if (staticVariant == StaticDisambiguationUnit.StaticVariant.StaticDestructor) {
//          _declaration = (new StaticDestructorStatementUnit(_lexer, _logger)).parse;
        }
        else if (staticVariant == StaticDisambiguationUnit.StaticVariant.StaticAttribute) {
          _lexer.push(token);
          _declaration = (new AttributeUnit(_lexer, _logger)).parse;
        }
				break;

			// Attribute Specifier
      case Token.Type.Colon:
        // Let the error go to the appropriate place
      case Token.Type.Const:
			case Token.Type.Synchronized:
			case Token.Type.Deprecated:
			case Token.Type.Final:
			case Token.Type.Override:
			case Token.Type.Auto:
			case Token.Type.Scope:
			case Token.Type.Private:
			case Token.Type.Public:
			case Token.Type.Package:
			case Token.Type.Protected:
			case Token.Type.Export:
			case Token.Type.Extern:
			case Token.Type.Align:
        _lexer.push(token);
        _declaration = (new AttributeUnit(_lexer, _logger)).parse;
        break;

			// Import Declaration
			case Token.Type.Import:
				auto import_path = (new ImportDeclarationUnit(_lexer, _logger)).parse;
				auto type = DeclarationNode.Type.ImportDeclaration;
				auto node = new ImportDeclarationNode(import_path);
        _declaration = new DeclarationNode(type, node);
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
				auto type = DeclarationNode.Type.ClassDeclaration;
				auto node = (new ClassDeclarationUnit(_lexer, _logger)).parse;
        _declaration = new DeclarationNode(type, node);
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
				auto type = DeclarationNode.Type.ConstructorDeclaration;
				auto node = (new ConstructorDeclarationUnit(_lexer, _logger)).parse;
        _declaration = new DeclarationNode(type, node);
				break;

			// Destructor Declaration
			case Token.Type.Cat:
				auto type = DeclarationNode.Type.DestructorDeclaration;
				auto node = (new DestructorDeclarationUnit(_lexer, _logger)).parse;
        _declaration = new DeclarationNode(type, node);
				break;

			// Version Block
			case Token.Type.Version:
				auto tree = (new VersionStatementUnit(_lexer, _logger)).parse;
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
				if (decl.type == TypeDeclarationNode.Type.FunctionDeclaration) {
					auto node = decl.node;
					auto type = DeclarationNode.Type.FunctionDeclaration;
          _declaration = new DeclarationNode(type, node);
				}
        else if (decl.type == TypeDeclarationNode.Type.VariableDeclaration) {
          auto node = decl.node;
          auto type = DeclarationNode.Type.VariableDeclaration;
          _declaration = new DeclarationNode(type, node);
        }
				break;
		}
		return false;
	}
}
