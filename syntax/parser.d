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
import lex.tokens;

import syntax.nodes;
import syntax.moduleunit;

class Parser {
private:
	Lexer _lexer;

public:
	this(Stream stream) {
		super(stream);
		_lexer = new DLexer(stream);
	}

	override AbstractSyntaxTree parse() {
		ParseUnit parseUnit = new ModuleUnit();
		parseUnit.lexer = _lexer;
		return parseUnit.parse();
	}
}
