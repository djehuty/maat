/*
 * module_unit.d
 *
 * This module parses a D source file. It is the root parse unit.
 * 
 * Author: Dave Wilkinson
 * Originated: February 6th 2010
 *
 */

module syntax.module_unit;

import lex.lexer;
import lex.token;

import logger;

import ast.module_node;
import ast.declaration_node;

import syntax.module_declaration_unit;
import syntax.declaration_unit;

import tango.io.Stdout;

/*

  Module => module ModuleDecl
          | Declaration

*/

class ModuleUnit {
private:
	char[] _name;
	DeclarationNode[] _declarations;
	Lexer _lexer;
	Logger _logger;

public:
	this(Lexer lexer, Logger logger) {
		_lexer = lexer;
		_logger = logger;
	}

	ModuleNode parse() {
		Token token;
		for (;;) {
			token = _lexer.pop();
			if (token.type == 0) {
				break;
			}

			switch(token.type) {
				case Token.Type.Module:
					if (_name !is null) {
						_logger.error(_lexer, token, "Module declaration should be on one of the first lines of the file.");
					}
					_name = (new ModuleDeclarationUnit(_lexer, _logger)).parse;
					break;
				default:
					_lexer.push(token);
					_declarations ~= (new DeclarationUnit(_lexer, _logger)).parse;
					break;
			}

			if (_logger.errors) {
				return null;
			}
		}
		return new ModuleNode(_name, _declarations);
	}
}
