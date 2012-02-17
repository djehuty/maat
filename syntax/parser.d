/*
 * parser.d
 *
 * This module will provide a parser for the D programming language.
 *
 * Author: Dave Wilkinson
 * Originated: February 1st, 2010
 *
 */

module syntax.parser;

import lex.lexer;
import lex.token;

import logger;

import syntax.module_unit;

import ast.module_node;

class Parser {
private:
	Lexer _lexer;

public:
	this(Lexer lex) {
		_lexer = lex;
	}

	ModuleNode parse(Logger logger) {
		auto parseUnit = new ModuleUnit(_lexer, logger);
		auto tree = parseUnit.parse();
		return tree;
	}
}
