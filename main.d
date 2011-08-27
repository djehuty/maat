import lex.lexer;
import lex.token;

import tango.io.Stdout;

int main() {
	Lexer.tokenize("test/test.di");
	Token t = Lexer.pop();
	t = Lexer.pop();
	
	Stdout("Token: ")(Token.Type.Module).newline;
	Stdout("Token: ")(Token.Type.Final).newline;
	Stdout("Token: ")(t.type).newline;
	if (t.string !is null) {
		Stdout("Data: ")(t.string).newline;
	}
	return 0;
}
