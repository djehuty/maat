/*
 * basic_type_unit.d
 *
 */

module syntax.basic_type_unit;

import ast.type_node;

import lex.lexer;
import lex.token;
import logger;

/*

	BasicType => bool
	           | byte
	           | ubyte
	           | short
	           | ushort
	           | int
	           | uint
	           | long
	           | ulong
	           | char
	           | wchar
	           | dchar
	           | float
	           | double
	           | real
	           | ifloat
	           | idouble
	           | ireal
	           | cfloat
	           | cdouble
	           | creal
	           | void
	           | . IdentifierList
	           | IdentifierList
	           | Typeof ( . IdentifierList )?

	IdentifierList => Identifier . IdentifierList
	                | Identifier
	                | TemplateInstance . IdentifierList
	                | TemplateInstance

*/

class BasicTypeUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

	TypeNode _typeNode;

  char[] _cur_string = "";

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	TypeNode parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

    if (_typeNode is null && _cur_string.length > 0) {
      _typeNode = new TypeNode(TypeNode.Type.UserDefined, null, _cur_string);
    }

		return _typeNode;
	}

	bool tokenFound(Token token) {
    if (_state == 1 || _state == 2) {
      // Identifier list
      if (_state == 2 && token.type == Token.Type.Dot) {
        // Good
        _cur_string ~= ".";
        _state = 1;
      }
      else if (_state == 1 && token.type == Token.Type.Identifier) {
        // Good.
        _cur_string ~= token.string;
        _state = 2;
      }
      else {
        // Done
        _lexer.push(token);
        return false;
      }

      return true;
    }

		switch (token.type) {
			case Token.Type.Bool:
				_typeNode = new TypeNode(TypeNode.Type.Bool, null, null);
				return false;

			case Token.Type.Byte:
				_typeNode = new TypeNode(TypeNode.Type.Byte, null, null);
				return false;

			case Token.Type.Ubyte:
				_typeNode = new TypeNode(TypeNode.Type.Ubyte, null, null);
				return false;

			case Token.Type.Short:
				_typeNode = new TypeNode(TypeNode.Type.Short, null, null);
				return false;

			case Token.Type.Ushort:
				_typeNode = new TypeNode(TypeNode.Type.Ushort, null, null);
				return false;

			case Token.Type.Int:
				_typeNode = new TypeNode(TypeNode.Type.Int, null, null);
				return false;

			case Token.Type.Uint:
				_typeNode = new TypeNode(TypeNode.Type.Uint, null, null);
				return false;

			case Token.Type.Long:
				_typeNode = new TypeNode(TypeNode.Type.Long, null, null);
				return false;

			case Token.Type.Ulong:
				_typeNode = new TypeNode(TypeNode.Type.Ulong, null, null);
				return false;

			case Token.Type.Char:
				_typeNode = new TypeNode(TypeNode.Type.Char, null, null);
				return false;

			case Token.Type.Wchar:
				_typeNode = new TypeNode(TypeNode.Type.Wchar, null, null);
				return false;

			case Token.Type.Dchar:
				_typeNode = new TypeNode(TypeNode.Type.Dchar, null, null);
				return false;

			case Token.Type.Float:
				_typeNode = new TypeNode(TypeNode.Type.Float, null, null);
				return false;

			case Token.Type.Double:
				_typeNode = new TypeNode(TypeNode.Type.Double, null, null);
				return false;

			case Token.Type.Real:
				_typeNode = new TypeNode(TypeNode.Type.Real, null, null);
				return false;

			case Token.Type.Ifloat:
				_typeNode = new TypeNode(TypeNode.Type.Ifloat, null, null);
				return false;

			case Token.Type.Idouble:
				_typeNode = new TypeNode(TypeNode.Type.Idouble, null, null);
				return false;

			case Token.Type.Ireal:
				_typeNode = new TypeNode(TypeNode.Type.Ireal, null, null);
				return false;

			case Token.Type.Cfloat:
				_typeNode = new TypeNode(TypeNode.Type.Cfloat, null, null);
				return false;

			case Token.Type.Cdouble:
				_typeNode = new TypeNode(TypeNode.Type.Cdouble, null, null);
				return false;

			case Token.Type.Creal:
				_typeNode = new TypeNode(TypeNode.Type.Creal, null, null);
				return false;

			case Token.Type.Void:
				_typeNode = new TypeNode(TypeNode.Type.Void, null, null);
				return false;

			case Token.Type.Identifier:
				// Named Type, could be a scoped list
        _cur_string ~= token.string;
        _state = 2;
        break;

			// Scope Operator
			case Token.Type.Dot:
        _state = 1;
        _cur_string ~= ".";
				break;

			case Token.Type.Typeof:
				// TypeOfExpression
				// TODO: this
				break;

			default:
				// Error:
				// TODO:
				break;
		}
		return true;
	}
}
