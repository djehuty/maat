import lexer;
import token;

import tango.io.Stdout;

int main() {
	Lexer.tokenize("test/test.di");
	Token t = Lexer.pop();
	
	Stdout("Token: ")(Token.Type.Module).newline;
	Stdout("Token: ")(t.type).newline;
	return 0;
}
