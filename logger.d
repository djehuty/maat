import lex.token;
import lex.lexer;

import tango.io.Stdout;
import tango.util.Convert;
import tango.text.Util;

class Logger {
private:
	bool _errors = false;

	void _printerror(Lexer lexer, char[] msg, char[] desc, char[][] usages, uint line, uint column) {
		Stdout("Syntax Error: ")(lexer.filename).newline;
		Stdout("   Line (")(line)(":")(column)(") ")(lexer.line(line).replace('\t', ' ')).newline;
		uint position = to!(char[])(line).length + 1 + to!(char[])(column).length + 11;
		for (uint i; i < position; i++) {
			Stdout(" ");
		}
		Stdout("\x1b[1;31m");
		for (uint i = 0; i < column-1; i++) {
			Stdout("-");
		}
		Stdout("^\x1b[0;37m").newline;
		//Console.forecolor = Color.Gray;
		Stdout("   Reason: ")(msg).newline;
		if (desc !is null) {
			Stdout("   Hint: \x1b[1;33m")(desc)("\x1b[0;37m").newline;
		}
		if (usages !is null) {
			Stdout("   Usage: ")("\x1b[0;34m")(usages[0])("\x1b[0;37m").newline;
			foreach(usage; usages[1..$]) {
				Stdout("          ")("\x1b[0;34m")(usage)("\x1b[0;37m").newline;
			}
		}
		_errors = true;
	}

public:
	void error(Lexer lexer, Token token, char[] msg, char[] desc = null, char[][] usages = null) {
		_printerror(lexer, msg, desc, usages, token.line, token.column);
	}

	void errorAtEnd(Lexer lexer, Token token, char[] msg, char[] desc = null, char[][] usages = null) {
		_printerror(lexer, msg, desc, usages, token.lineEnd, token.columnEnd);
	}

	bool errors() {
		return _errors;
	}

  void println(char[] string) {
    Stdout(string).newline;
  }
}
