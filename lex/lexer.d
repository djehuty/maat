module lex.lexer;

import lex.token;

// Tango is the worst
import tango.io.device.File;
import tango.io.Stdout;
import Text = tango.text.Util;

class Lexer {
private:

	void _error(char[] msg) {
		//Console.forecolor = Color.Red;
		//Console.putln("Lexical Error: file.d @ ", _lineNumber+1, ":", _pos+1, " - ", msg);
		//Console.putln();
	}

	// Describe the number lexer states
	enum LexerState : uint {
		Normal,
		String,
		Comment,
		Identifier,
		Integer,
		FloatingPoint
	}

	LexerState state;
	bool inEscape;
	bool foundLeadingChar;
	bool foundLeadingSlash;
	uint nestedCommentDepth;

	// Describe the string lexer states
	enum StringType : uint {
		DoubleQuote,		// "..."
		WhatYouSeeQuote,	// `...`
		RawWhatYouSeeQuote,	// r"..."
		Character,			// '.'
	}

	StringType inStringType;

	// Describe the comment lexer states
	enum CommentType : uint {
		BlockComment,
		LineComment,
		NestedComment
	}

	CommentType inCommentType;
	char[] cur_string;

	char[] _line;
	char[] _filename = "";
	size_t _lineNumber;
	size_t _pos;

	static const Token.Type[] tokenMapping = [
		'!':Token.Type.Bang,
		':':Token.Type.Colon,
		';':Token.Type.Semicolon,
		'.':Token.Type.Dot,
		',':Token.Type.Comma,
		'(':Token.Type.LeftParen,
		')':Token.Type.RightParen,
		'{':Token.Type.LeftCurly,
		'}':Token.Type.RightCurly,
		'[':Token.Type.LeftBracket,
		']':Token.Type.RightBracket,
		'<':Token.Type.LessThan,
		'>':Token.Type.GreaterThan,
		'=':Token.Type.Assign,
		'+':Token.Type.Add,
		'-':Token.Type.Sub,
		'~':Token.Type.Cat,
		'*':Token.Type.Mul,
		'/':Token.Type.Div,
		'^':Token.Type.Xor,
		'|':Token.Type.Or,
		'&':Token.Type.And,
		'%':Token.Type.Mod,
		];

	int cur_base;
	ulong cur_integer;
	bool cur_integer_signed;
	ulong cur_decimal;
	ulong cur_exponent;
	ulong cur_denominator;
	bool inDecimal;
	bool inExponent;


	char[][] _lines;

	// Simple stack of tokens
	Token[] _bank;

	void _bank_push(Token token) {
		_bank = _bank ~ [token];
	}

	bool _bank_empty() {
		return _bank.length == 0;
	}

	Token _bank_pop() {
		Token ret = _bank[$-1];
		_bank = _bank[0..$-1];
		return ret;
	}

public:
	char[] filename() {
		return _filename;
	}

	char[] line(uint idx) {
		return _lines[idx-1];
	}

	void push(Token token) {
		_bank_push(token);
	}

	Token pop() {
		if (!_bank_empty) {
			return _bank_pop();
		}
		Token current = new Token(Token.Type.Invalid);
		current.line = _lineNumber;
		current.column = _pos + 1;

		// will give us a string for the line of utf8 characters.
		for(;;) {
			if (_line is null || _pos >= _line.length) {
				if (_lineNumber >= _lines.length) {
					// EOF
					return current;
				}
				_line = _lines[_lineNumber];
				_lineNumber++;
				_pos = 0;
				current.line = current.line + 1;
				current.column = 1;
			}

			// now break up the line into tokens
			// the return for the line is whitespace, and can be ignored

			for(; _pos <= _line.length; _pos++) {
				char chr;
				if (_pos == _line.length) {
					chr = '\n';
				}
				else {
					chr = _line[_pos];
				}
				switch (state) {
					default:
						// error
						_error("error");
						return Token.init;

					case LexerState.Normal:
						Token.Type newType = tokenMapping[chr];
						// Comments
						if (current.type == Token.Type.Div) {
							if (newType == Token.Type.Add) {
								inEscape = false;
								foundLeadingSlash = false;
								foundLeadingChar = false;
								nestedCommentDepth = 1;
								current.type = Token.Type.Invalid;
								state = LexerState.Comment;
								inCommentType = CommentType.NestedComment;
								cur_string = "";
								continue;
							}
							else if (newType == Token.Type.Div) {
								cur_string = _line[_pos+1..$];
								current.type = Token.Type.Comment;
								current.string = cur_string;
								current.lineEnd = _lineNumber;
								_pos = _line.length;
								return current;
							}
							else if (newType == Token.Type.Mul) {
								inEscape = false;
								foundLeadingSlash = false;
								foundLeadingChar = false;
								nestedCommentDepth = 1;
								current.type = Token.Type.Invalid;
								state = LexerState.Comment;
								inCommentType = CommentType.BlockComment;
								cur_string = "";
								continue;
							}
						}

						if (newType != Token.Type.Invalid) {
							switch(current.type) {
								case Token.Type.And: // &
									if (newType == Token.Type.And) {
										// &&
										current.type = Token.Type.LogicalAnd;
									}
									else if (newType == Token.Type.Assign) {
										// &=
										current.type = Token.Type.AndAssign;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.Or: // |
									if (newType == Token.Type.Or) {
										// ||
										current.type = Token.Type.LogicalOr;
									}
									else if (newType == Token.Type.Assign) {
										// |=
										current.type = Token.Type.OrAssign;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.Add: // +
									if (newType == Token.Type.Assign) {
										// +=
										current.type = Token.Type.AddAssign;
									}
									else if (newType == Token.Type.Add) {
										// ++
										current.type = Token.Type.Increment;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.Sub: // -
									if (newType == Token.Type.Assign) {
										// -=
										current.type = Token.Type.SubAssign;
									}
									else if (newType == Token.Type.Sub) {
										// --
										current.type = Token.Type.Decrement;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.Div: // /
									if (newType == Token.Type.Assign) {
										// /=
										current.type = Token.Type.DivAssign;
									}
									else if (newType == Token.Type.Add) {
										// /+
										current.type = Token.Type.Comment;
									}
									else if (newType == Token.Type.Div) {
										// //
										current.type = Token.Type.Comment;
									}
									else if (newType == Token.Type.Mul) {
										// /*
										current.type = Token.Type.Comment;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.Mul: // *
									if (newType == Token.Type.Assign) {
										// *=
										current.type = Token.Type.MulAssign;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.Mod: // %
									if (newType == Token.Type.Assign) {
										// %=
										current.type = Token.Type.ModAssign;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.Xor: // ^
									if (newType == Token.Type.Assign) {
										// ^=
										current.type = Token.Type.XorAssign;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.Cat: // ~
									if (newType == Token.Type.Assign) {
										// ~=
										current.type = Token.Type.CatAssign;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.Assign: // =
									if (newType == Token.Type.Assign) {
										// ==
										current.type = Token.Type.Equals;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.LessThan: // <
									if (newType == Token.Type.LessThan) {
										// <<
										current.type = Token.Type.ShiftLeft;
									}
									else if (newType == Token.Type.Assign) {
										// <=
										current.type = Token.Type.LessThanEqual;
									}
									else if (newType == Token.Type.GreaterThan) {
										// <>
										current.type = Token.Type.LessThanGreaterThan;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.GreaterThan: // >
									if (newType == Token.Type.GreaterThan) {
										// >>
										current.type = Token.Type.ShiftRight;
									}
									else if (newType == Token.Type.Assign) {
										// >=
										current.type = Token.Type.GreaterThanEqual;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.ShiftLeft: // <<
									if (newType == Token.Type.Assign) {
										// <<=
										current.type = Token.Type.ShiftLeftAssign;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.ShiftRight: // >>
									if (newType == Token.Type.Assign) {
										// >>=
										current.type = Token.Type.ShiftRightAssign;
									}
									else if (newType == Token.Type.GreaterThan) {
										// >>>
										current.type = Token.Type.ShiftRightSigned;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.ShiftRightSigned: // >>>
									if (newType == Token.Type.Assign) {
										// >>>=
										current.type = Token.Type.ShiftRightSignedAssign;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.LessThanGreaterThan: // <>
									if (newType == Token.Type.Assign) {
										// <>=
										current.type = Token.Type.LessThanGreaterThanEqual;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.Bang: // !
									if (newType == Token.Type.LessThan) {
										// !<
										current.type = Token.Type.NotLessThan;
									}
									else if (newType == Token.Type.GreaterThan) {
										// !>
										current.type = Token.Type.NotGreaterThan;
									}
									else if (newType == Token.Type.Assign) {
										// !=
										current.type = Token.Type.NotEquals;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.NotLessThan: // !<
									if (newType == Token.Type.GreaterThan) {
										// !<>
										current.type = Token.Type.NotLessThanGreaterThan;
									}
									else if (newType == Token.Type.Assign) {
										// !<=
										current.type = Token.Type.NotLessThanEqual;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.NotGreaterThan: // !>
									if (newType == Token.Type.Assign) {
										// !>=
										current.type = Token.Type.NotGreaterThanEqual;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.NotLessThanGreaterThan: // !<>
									if (newType == Token.Type.Assign) {
										// !<>=
										current.type = Token.Type.NotLessThanGreaterThanEqual;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.Dot: // .
									if (newType == Token.Type.Dot) {
										// ..
										current.type = Token.Type.Slice;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.Slice: // ..
									if (newType == Token.Type.Dot) {
										// ...
										current.type = Token.Type.Variadic;
									}
									else {
										goto default;
									}
									break;
								case Token.Type.Invalid:
									current.type = tokenMapping[chr];
									break;
								default:
									// Token Error
									if (current.type != Token.Type.Invalid) {
										current.columnEnd = _pos;
										current.lineEnd = _lineNumber;
										return current;
									}
//									_error("Unknown operator.");
									return Token.init;
							}
							
							continue;
						}

						// A character that will switch states continues

						// Strings
						if (chr == '\'') {
							state = LexerState.String;
							inStringType = StringType.Character;
							cur_string = "";
							if (current.type != Token.Type.Invalid) {
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								_pos++;
								return current;
							}
							continue;
						}
						else if (chr == '"') {
							state = LexerState.String;
							inStringType = StringType.DoubleQuote;
							cur_string = "";
							if (current.type != Token.Type.Invalid) {
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								_pos++;
								return current;
							}
							continue;
						}
						else if (chr == '`') {
							state = LexerState.String;
							inStringType = StringType.WhatYouSeeQuote;
							cur_string = "";
							if (current.type != Token.Type.Invalid) {
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								_pos++;
								return current;
							}
							continue;
						}

						// Whitespace
						else if (chr == ' ' || chr == '\t' || chr == '\n') {
							if (current.type != Token.Type.Invalid) {
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								_pos++;
								return current;
							}
							current.column = current.column + 1;
							continue;
						}

						// Identifiers
						else if ((chr >= 'a' && chr <= 'z') || (chr >= 'A' && chr <= 'Z') || chr == '_') {
							state = LexerState.Identifier;
							cur_string = "";
							if (current.type != Token.Type.Invalid) {
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								return current;
							}
							goto case LexerState.Identifier;
						}

						// Numbers
						else if (chr >= '0' && chr <= '9') {
							// reset to invalid base
							cur_base = 0;
							cur_decimal = 0;
							cur_denominator = 1;
							cur_exponent = 0;

							if (current.type == Token.Type.Dot) {
								current.type = Token.Type.Invalid;
								inDecimal = true;
								inExponent = false;
								cur_integer = 0;
								cur_base = 10;
								state = LexerState.FloatingPoint;
								goto case LexerState.FloatingPoint;
							}
							else {
								state = LexerState.Integer;

								if (current.type != Token.Type.Invalid) {
									current.columnEnd = _pos;
									current.lineEnd = _lineNumber;
									return current;
								}
								goto case LexerState.Integer;
							}
						}
						break;

					case LexerState.String:
						if (inEscape) {
							inEscape = false;
							if (chr == 't') {
								chr = '\t';
							}
							else if (chr == 'b') {
								chr = '\b';
							}
							else if (chr == 'r') {
								chr = '\r';
							}
							else if (chr == 'n') {
								chr = '\n';
							}
							else if (chr == '0') {
								chr = '\0';
							}
							else if (chr == 'x' || chr == 'X') {
								// BLEH!
							}
							cur_string ~= chr;
							continue;
						}

						if (inStringType == StringType.DoubleQuote) {
							if (chr == '"') {
								state = LexerState.Normal;
								current.type = Token.Type.StringLiteral;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								if (cur_string !is null) {
									current.string = cur_string;
								}
								_pos++;
								return current;
							}
						}
						else if (inStringType == StringType.RawWhatYouSeeQuote) {
							if (chr == '"') {
								state = LexerState.Normal;
								current.type = Token.Type.StringLiteral;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								if (cur_string !is null) {
									current.string = cur_string;
								}
								_pos++;
								return current;
							}
						}
						else if (inStringType == StringType.WhatYouSeeQuote) {
							if (chr == '`') {
								state = LexerState.Normal;
								current.type = Token.Type.StringLiteral;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								if (cur_string !is null) {
									current.string = cur_string;
								}
								_pos++;
								return current;
							}
						}
						else { // StringType.Character
							if (chr == '\'') {
								if (cur_string.length > 1) {
									// error
									goto default;
								}
								state = LexerState.Normal;
								current.type = Token.Type.CharacterLiteral;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								if (cur_string !is null) {
									current.string = cur_string;
								}
								_pos++;
								return current;
							}
						}

						if ((inStringType == StringType.DoubleQuote || inStringType == StringType.Character) && (chr == '\\')) {
							// Escaped Characters
							inEscape = true;
						}
						else {
							cur_string ~= chr;
						}
						continue;
					case LexerState.Comment:
						if (inEscape) {
							// Ignore escaped characters
							cur_string ~= [chr];
							inEscape = false;
						}
						else if (chr == '\\') {
							inEscape = true;
							foundLeadingChar = false;
							foundLeadingSlash = false;
						}
						else if (chr == '/' && !foundLeadingChar && inCommentType == CommentType.NestedComment) {
							foundLeadingSlash = true;
							cur_string ~= [chr];
						}
						else if (chr == '+' && foundLeadingSlash) {
							foundLeadingSlash = false;
							cur_string ~= [chr];
							nestedCommentDepth++;
						}
						else if ((chr == '*' && inCommentType == CommentType.BlockComment) ||
						         (chr == '+' && inCommentType == CommentType.NestedComment)) {
							cur_string ~= [chr];
							foundLeadingChar = true;
							foundLeadingSlash = false;
						}
						else if (foundLeadingChar && chr == '/') {
							nestedCommentDepth--;

							// Good
							if (nestedCommentDepth == 0) {
								state = LexerState.Normal;
								current.string = cur_string[0..$-1];
								current.type = Token.Type.Comment;
								_pos++;
								return current;
							}
							cur_string ~= [chr];

							foundLeadingChar = false;
							foundLeadingSlash = false;
						}
						else {
							foundLeadingChar = false;
							foundLeadingSlash = false;
							cur_string ~= [chr];
						}
						continue;
					case LexerState.Identifier:
						// check for valid succeeding character
						if ((chr < 'a' || chr > 'z') && (chr < 'A' || chr > 'Z') && chr != '_' && (chr < '0' || chr > '9')) {
							// Invalid identifier symbol
							static Token.Type keywordStart = Token.Type.Abstract;
							static const char[][] keywordList = ["abstract", "alias", "align", "asm", "assert", "auto",
								"body", "bool", "break", "byte", "case", "cast","catch","cdouble","cent","cfloat","char",
								"class","const","continue","creal","dchar","debug","default","delegate","delete","deprecated",
								"do","double","else","enum","export","extern","false","final","finally","float","for","foreach",
								"foreach_reverse","function","goto","idouble","if","ifloat","import","in","inout","int","interface",
								"invariant","ireal","is","lazy","long","macro","mixin","module","new","null","out","override",
								"package","pragma","private","protected","public","real","ref","return","scope","short","static",
								"struct","super","switch","synchronized","template","this","throw","true","try",
								"typedef","typeid","typeof","ubyte","ucent","uint","ulong","union","unittest","ushort","version",
								"void","volatile","wchar","while","with"
							];
							current.type = Token.Type.Identifier;

							foreach(size_t i, keyword; keywordList) {
								if (cur_string == keyword) {
									current.type = cast(Token.Type)(keywordStart + i);
									cur_string = null;
									break;
								}
							}

							if (cur_string !is null) {
								current.string = cur_string;
							}
							state = LexerState.Normal;
							if (current.type != Token.Type.Invalid) {
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;
								return current;
							}
							goto case LexerState.Normal;
						}
						cur_string ~= chr;
						continue;
					case LexerState.Integer:
						// check for valid succeeding character

						// we may want to switch to floating point state
						if (chr == '.') {
							if (cur_base <= 0) {
								cur_base = 10;
							}
							else if (cur_base == 2) {
								_error("Cannot have binary floating point literals");
								return Token.init;
							}
							else if (cur_base == 8) {
								_error("Cannot have octal floating point literals");
								return Token.init;
							}

							// Reset this just in case, it will get interpreted
							// in the Floating Point state
							inDecimal = false;
							inExponent = false;

							state = LexerState.FloatingPoint;
							goto case LexerState.FloatingPoint;
						}
						else if ((chr == 'p' || chr == 'P') && cur_base == 16) {
							// Reset this just in case, it will get interpreted
							// in the Floating Point state
							inDecimal = false;
							inExponent = false;

							state = LexerState.FloatingPoint;
							goto case LexerState.FloatingPoint;
						}
						else if (chr == '_') {
							// ignore
							if (cur_base == -1) {
								// OCTAL
								cur_base = 8;
							}
						}
						else if (cur_base == 0) {
							// this is the first value
							if (chr == '0') {
								// octal or 0 or 0.0, etc
								// use an invalid value so we can decide
								cur_base = -1;
								cur_integer = 0;
							}
							else if (chr >= '1' && chr <= '9') {
								cur_base = 10;
								cur_integer = (chr - '0');
							}
							// Cannot be any other value
							else {
								_error("Integer literal expected.");
								return Token.init;
							}
						}
						else if (cur_base == -1) {
							// this is the second value of an ambiguous base
							if (chr >= '0' && chr <= '7') {
								// OCTAL
								cur_base = 8;
								cur_integer = (chr - '0');
							}
							else if (chr == 'x' || chr == 'X') {
								// HEX
								cur_base = 16;
							}
							else if (chr == 'b' || chr == 'B') {
								// BINARY
								cur_base = 2;
							}
							else {
								// 0 ?
								current.type = Token.Type.IntegerLiteral;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
						}
						else if (cur_base == 16) {
							if ((chr < '0' || chr > '9') && (chr < 'a' || chr > 'f') && (chr < 'A' || chr > 'F')) {
								current.type = Token.Type.IntegerLiteral;
								current.integer = cur_integer;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
							else {
								cur_integer *= cur_base;
								if (chr >= 'a' && chr <= 'f') {
									cur_integer += 10 + (chr - 'a');
								}
								else if (chr >= 'A' && chr <= 'F') {
									cur_integer += 10 + (chr - 'A');
								}
								else {
									cur_integer += (chr - '0');
								}
							}
						}
						else if (cur_base == 10) {
							if (chr < '0' || chr > '9') {
								current.type = Token.Type.IntegerLiteral;
								current.integer = cur_integer;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
							else {
								cur_integer *= cur_base;
								cur_integer += (chr - '0');
							}
						}
						else if (cur_base == 8) {
							if (chr >= '8' && chr <= '9') {
								_error("Digits higher than 7 in an octal integer literal are invalid.");
								return Token.init;
							}
							else if (chr < '0' || chr > '7') {
								current.type = Token.Type.IntegerLiteral;
								current.integer = cur_integer;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
							else {
								cur_integer *= cur_base;
								cur_integer += (chr - '0');
							}
						}
						else if (cur_base == 2) {
							if (chr < '0' || chr > '1') {
								current.type = Token.Type.IntegerLiteral;
								current.integer = cur_integer;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
							else {
								cur_integer *= cur_base;
								cur_integer += (chr - '0');
							}
						}

						continue;
					case LexerState.FloatingPoint:
						if (chr == '_') {
							continue;
						}
						else if (chr == '.' && (cur_base == 10 || cur_base == 16)) {
							// We are now parsing the decimal portion
							if (inDecimal) {
								_error("Only one decimal point is allowed per floating point literal.");
								return Token.init;
							}
							else if (inExponent) {
								_error("Cannot put a decimal point after an exponent in a floating point literal.");
							}
							inDecimal = true;
						}
						else if (cur_base == 16 && (chr == 'p' || chr == 'P')) {
							// We are now parsing the exponential portion
							inDecimal = false;
							inExponent = true;
							cur_exponent = -1;
						}
						else if (cur_base == 10 && (chr == 'e' || chr == 'E')) {
							// We are now parsing the exponential portion
							inDecimal = false;
							inExponent = true;
							cur_exponent = -1;
						}
						else if (cur_base == 10) {
							if (chr == 'p' || chr == 'P') {
								_error("Cannot have a hexidecimal exponent in a non-hexidecimal floating point literal.");
								return Token.init;
							}
							else if (chr < '0' || chr > '9') {
								if (inExponent && cur_exponent == -1) {
									_error("You need to specify a value for the exponent part of the floating point literal.");
									return Token.init;
								}
								current.type = Token.Type.FloatingPointLiteral;
								double value = cast(double)cur_integer + (cast(double)cur_decimal / cast(double)cur_denominator);
								double exp = 1;
								for(size_t i = 0; i < cur_exponent; i++) {
									exp *= cur_base;
								}
								value *= exp;
								current.decimal = value;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
							else if (inExponent) {
								if (cur_exponent == -1) {
									cur_exponent = 0;
								}
								cur_exponent *= cur_base;
								cur_exponent += (chr - '0');
							}
							else {
								cur_decimal *= cur_base;
								cur_denominator *= cur_base;
								cur_decimal += (chr - '0');
							}
						}
						else { // cur_base == 16
							if ((chr < '0' || chr > '9') && (chr < 'a' || chr > 'f') && (chr < 'A' || chr > 'F')) {
								if (inDecimal && !inExponent) {
									_error("You need to provide an exponent with the decimal portion of a hexidecimal floating point number. Ex: 0xff.3p2");
									return Token.init;
								}
								if (inExponent && cur_exponent == -1) {
									_error("You need to specify a value for the exponent part of the floating point literal.");
									return Token.init;
								}
								current.type = Token.Type.FloatingPointLiteral;
								double value = cast(double)cur_integer + (cast(double)cur_decimal / cast(double)cur_denominator);
								double exp = 1;
								for(size_t i = 0; i < cur_exponent; i++) {
									exp *= 2;
								}
								value *= exp;
								current.decimal = value;
								current.columnEnd = _pos;
								current.lineEnd = _lineNumber;

								state = LexerState.Normal;
								return current;
							}
							else if (inExponent) {
								if (cur_exponent == -1) {
									cur_exponent = 0;
								}
								cur_exponent *= cur_base;
								if (chr >= 'A' && chr <= 'F') {
									cur_exponent += 10 + (chr - 'A');
								}
								else if (chr >= 'a' && chr <= 'f') {
									cur_exponent += 10 + (chr - 'a');
								}
								else {
									cur_exponent += (chr - '0');
								}
							}
							else {
								cur_decimal *= cur_base;
								cur_denominator *= cur_base;
								if (chr >= 'A' && chr <= 'F') {
									cur_decimal += 10 + (chr - 'A');
								}
								else if (chr >= 'a' && chr <= 'f') {
									cur_decimal += 10 + (chr - 'a');
								}
								else {
									cur_decimal += (chr - '0');
								}
							}
						}
						continue;
				}
			}

			if (current.type != Token.Type.Invalid) {
				current.columnEnd = _pos;
				current.lineEnd = _lineNumber;
				return current;
			}
			current.line = current.line + 1;
			current.column = 1;

			if (state != LexerState.String && state != LexerState.Comment) {
				state = LexerState.Normal;
			}
			else if (state == LexerState.String) {
				if (inStringType == StringType.Character) {
					_error("Unmatched character literal.");
					return Token.init;
				}
				cur_string ~= '\n';
			}
		}

		return Token.init;
	}

	this(char[] file) {
		auto content = cast(char[])File.get(file);
		_filename = "file.di";
		_lines = Text.splitLines(content);
	}
}
