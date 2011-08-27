import lex.lexer;
import lex.token;

import syntax.parser;

import tango.io.Stdout;

int main() {
	auto lex = new Lexer("test/test.di");

	Parser p = new Parser(lex);
	auto ast = p.parse();

	return 0;
}
