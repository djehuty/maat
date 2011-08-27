module syntax.parseunit;

import syntax.ast;

import lex.lexer;
import lex.token;

import tango.io.Stdout;
import tango.util.Convert;

class ParseUnit {
private:
	uint _firstLine;
	uint _firstColumn;

	uint _lastLine;
	uint _lastColumn;

	uint _state;

	Lexer _lexer;
	AbstractSyntaxTree _tree;
	AbstractSyntaxTree _root;
	static bool _error;
	Token current;

	void _printerror(char[] msg, char[] desc, char[][] usages, uint line, uint column) {
		Stdout("Syntax Error: ")(_lexer.filename).newline;
		Stdout("   Line: ")(line)(":")(column)(": ")(_lexer.line(line)).newline;
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
		_error = true;
	}

protected:

	uint state() {
		return _state;
	}

	void state(uint value) {
		_state = value;
	}

	void root(AbstractSyntaxTree ast) {
		_root = ast;
	}

	AbstractSyntaxTree root() {
		return _root;
	}

	final void errorAtStart(char[] msg, char[] desc = null, char[][] usages = null) {
		_printerror(msg, desc, usages, _firstLine, _firstColumn);
	}

	final void errorAtPrevious(char[] msg, char[] desc = null, char[][] usages = null) {
		_printerror(msg, desc, usages, _lastLine, _lastColumn);
	}

	final void error(char[] msg, char[] desc = null, char[][] usages = null) {
		_printerror(msg, desc, usages, current.line, current.column);
	}

	bool tokenFound(Token token) {
		return true;
	}

public:
	final AbstractSyntaxTree parse() {
		// get class name
		ClassInfo ci = this.classinfo;
		char[] className = ci.name.dup;

		// Do not have a lexer installed...
		if (_lexer is null) {
			return _tree;
		}

		// Go through every token...

		// Starting with the first
		do {
			current = _lexer.pop();

			if (current.type == 0) {
				return _root;
			}
		} while(current.type == Token.Type.Comment);

		// get position in lexer
		_firstLine = current.line;
		_firstColumn = current.column;

		do {
//			Console.putln("T: ", current.type, " ", current.value);
			if (!tokenFound(current)) {
				break;
			}
			if (_error) {
				break;
			}

			_lastLine = current.lineEnd;
			_lastColumn = current.columnEnd;
		} while((current = _lexer.pop()).type != 0);

		// Return resulting parse tree...
		return _root;
	}

	template expand(T) {
		AbstractSyntaxTree expand() {
			auto machine = new T();
			machine.lexer = _lexer;
			return machine.parse();
		}
	}

	Lexer lexer() {
		return _lexer;
	}

	void lexer(Lexer val) {
		_lexer = val;
	}
}
