module ast.type_node;

class TypeNode {
public:
	enum Type {
		Char,
		Dchar,
		Wchar,

		Int,
		Uint,

		Long,
		Ulong,

		Short,
		Ushort,

		Float,
		Double,
		Real,

		Ifloat,
		Idouble,
		Ireal,

		Cfloat,
		Cdouble,
		Creal,

		Byte,
		Ubyte,

		Bool,

		Void,
		
		Array,
		Hash,
		Pointer,

		UserDefined
	}

private:
	Type     _type;
	TypeNode _subtype;
	char[]   _identifier;

public:
	this(Type type, TypeNode subtype, char[] identifier) {
		_type = type;
		_subtype = subtype;
		_identifier = identifier;
	}

	Type type() {
		return _type;
	}

	TypeNode subtype() {
		return _subtype;
	}

	char[] identifier() {
		return _identifier;
	}
}
