module lex.token;

class Token {
public:
	enum Type {
		EOF,

		Comment,

		// Literals

		StringLiteral,				// "..." `...` r"..." x"..."
		CharacterLiteral,			// '.'
		Identifier,					// [a-zA-Z_][a-zA-Z0-9_]*
		IntegerLiteral,				// [0-9][0-9_]*, 0x[0-9a-fA-F][0-9a-fA-F_]*, etc
		FloatingPointLiteral,		// [0-9][0-9_]*\.[0-9][0-9_]*, 0x[0-9a-fA-F][0-9a-fA-F_]*p[0-9a-fA-F]+, etc

		// Symbols

		LeftParen,					// (
		RightParen,					// )
		LeftBracket,				// [
		RightBracket,				// ]
		LeftCurly,					// {
		RightCurly,					// }

		Bang,						// !
		Question,					// ?
		Colon,						// :
		Semicolon,					// ;

		Assign,						// =

		Equals,						// ==
		NotEquals,					// !=
		LessThan,					// <
		NotLessThan,				// !<
		GreaterThan,				// >
		NotGreaterThan,				// !>
		LessThanEqual,				// <=
		NotLessThanEqual,			// !<=
		GreaterThanEqual,			// >=
		NotGreaterThanEqual,		// !>=
		LessThanGreaterThan,		// <>
		NotLessThanGreaterThan,		// !<>
		LessThanGreaterThanEqual,	// <>=
		NotLessThanGreaterThanEqual,// !<>=

		ShiftLeft,					// <<
		ShiftLeftAssign,			// <<=
		ShiftRight,					// >>
		ShiftRightAssign,			// >>=
		ShiftRightSigned,			// >>>
		ShiftRightSignedAssign,		// >>>=

		Add,						// +
		AddAssign,					// +=

		Cat,						// ~
		CatAssign,					// ~=

		Sub,						// -
		SubAssign,					// -=

		Div,						// /
		DivAssign,					// /=

		Mul,						// *
		MulAssign,					// *=

		Xor,						// ^
		XorAssign,					// ^=

		Mod,						// %
		ModAssign,					// %=

		And,						// &
		LogicalAnd,					// &&
		AndAssign,					// &=

		Or,							// |
		LogicalOr,					// ||
		OrAssign,					// |=

		Increment,					// ++
		Decrement,					// --

		Dot,						// .
		Slice,						// ..
		Variadic,					// ...
		Comma,						// ,
		Dollar,						// $

		// Keywords

		Abstract,					// abstract
		Alias,						// alias
		Align,						// align
		Asm,						// asm
		Assert,						// assert
		Auto,						// auto

		Body,						// body
		Bool,						// bool
		Break,						// break
		Byte,						// byte

		Case,						// case
		Cast,						// cast
		Catch,						// catch
		Cdouble,					// cdouble
		Cent,						// cent
		Cfloat,						// cfloat
		Char,						// char
		Class,						// class
		Const,						// const
		Continue,					// continue
		Creal,						// creal

		Dchar,						// dchar
		Debug,						// debug
		Default,					// default
		Delegate,					// delegate
		Delete,						// delete
		Deprecated,					// deprecated
		Do,							// do
		Double,						// double

		Else,						// else
		Enum,						// enum
		Export,						// export
		Extern,						// extern

		False,						// false
		Final,						// final
		Finally,					// finally
		Float,						// float
		For,						// for
		Foreach,					// foreach
		Foreach_reverse,			// foreach_reverse
		Function,					// function

		Goto,						// goto

		Idouble,					// idouble
		If,							// if
		Ifloat,						// ifloat
		Import,						// import
		In,							// in
		Inout,						// inout
		Int,						// int
		Interface,					// interface
		Invariant,					// invariant
		Ireal,						// ireal
		Is,							// is

		Lazy,						// lazy
		Long,						// long

		Macro,						// macro
		Mixin,						// mixin
		Module,						// module

		New,						// new
		Null,						// null

		Out,						// out
		Override,					// override

		Package,					// package
		Pragma,						// pragma
		Private,					// private
		Protected,					// protected
		Public,						// public

		Real,						// real
		Ref,						// ref
		Return,						// return

		Scope,						// scope
		Short,						// short
		Static,						// static
		Struct,						// struct
		Super,						// super
		Switch,						// switch
		Synchronized,				// synchronized

		Template,					// template
		This,						// this
		Throw,						// throw
		True,						// true
		Try,						// try
		Typedef,					// typedef
		Typeid,						// typeid
		Typeof,						// typeof

		Ubyte,						// ubyte
		Ucent,						// ucent
		Uint,						// uint
		Ulong,						// ulong
		Union,						// union
		Unittest,					// unittest
		Ushort,						// ushort

		Version,					// version
		Void,						// void
		Volatile,					// volatile

		Wchar,						// wchar
		While,						// while
		With						// with
	}

private:
	Type _type;
	char[] _string;
	ulong _integer;
	double _decimal;

	long _line;
	long _column;

	uint _columnEnd;
	uint _lineEnd;

public:

	this(Type type) {
		_type = type;
	}

	Type type() {
		return _type;
	}

	void type(Type value) {
		_type = value;
	}

	void line(long value) {
		_line = value;
	}

	long line() {
		return _line;
	}

	void column(long value) {
		_column = value;
	}

	long column() {
		return _column;
	}

	void string(char[] value) {
		_string = value;
	}

	char[] string() {
		return _string;
	}

	void integer(ulong value) {
		_integer = value;
	}

	ulong integer() {
		return _integer;
	}

	void decimal(double value) {
		_decimal = value;
	}

	double decimal() {
		return _decimal;
	}

	void columnEnd(uint value) {
		_columnEnd = value;
	}

	uint columnEnd() {
		return _columnEnd;
	}

	void lineEnd(uint value) {
		_lineEnd = value;
	}

	uint lineEnd() {
		return _lineEnd;
	}
}
