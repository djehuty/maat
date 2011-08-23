module lexer;

import token;

// Tango is the worst
import tango.io.device.File;
import Text = tango.text.Util;

class Lexer {
public:
static:

	Token[] tokenize(char[] file) {
		char[][] lines;

		auto content = cast(char[])File.get(file);
		lines = Text.splitLines(content);

		Token t = new Token(Token.Type.Comment, "hello");
		return [t];
	}
}
