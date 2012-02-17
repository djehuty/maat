import lex.lexer;
import lex.token;

import logger;

import syntax.parser;

import tango.io.Stdout;

int main() {
	auto lex = new Lexer("test/stream.di");

	Parser p = new Parser(lex);
	Logger logger = new Logger();
	auto ast = p.parse(logger);

	return 0;
}
