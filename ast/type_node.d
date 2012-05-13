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
		if (_type == Type.UserDefined) {
			_identifier = identifier;
		}
	}

	Type type() {
		return _type;
	}

	TypeNode subtype() {
		return _subtype;
	}

	char[] identifier() {
		switch (_type) {
      case Type.Bool:
        return "bool";
			case Type.Char:
				return "char";
			case Type.Dchar:
				return "dchar";
			case Type.Wchar:
				return "wchar";
			case Type.Float:
				return "float";
			case Type.Ifloat:
				return "ifloat";
			case Type.Cfloat:
				return "cfloat";
			case Type.Double:
				return "double";
			case Type.Idouble:
				return "idouble";
			case Type.Cdouble:
				return "cdouble";
			case Type.Real:
				return "real";
			case Type.Ireal:
				return "ireal";
			case Type.Creal:
				return "creal";
			case Type.Byte:
				return "byte";
			case Type.Ubyte:
				return "ubyte";
			case Type.Short:
				return "short";
			case Type.Ushort:
				return "ushort";
			case Type.Int:
				return "int";
			case Type.Uint:
				return "uint";
			case Type.Long:
				return "long";
			case Type.Ulong:
				return "ulong";
			case Type.Void:
				return "void";
			case Type.Array:
        if (_subtype !is null) {
          return _subtype.identifier ~ "[]";
        }
			case Type.Pointer:
        if (_subtype !is null) {
          return _subtype.identifier ~ "*";
        }
      case Type.UserDefined:
        return _identifier;
      default:
        return "x";
		}
		return _identifier;
	}
}
