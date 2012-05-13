module ast.declarator_node;

import ast.variable_declaration_node;

import ast.type_node;

class DeclaratorNode {
private:
	char[] _name;
  TypeNode _type;

	VariableDeclarationNode[] _parameters;

public:
	this(char[] name, TypeNode type, VariableDeclarationNode[] parameters) {
		_name = name.dup;
    _type = type;
    if (parameters is null) {
      _parameters = null;
    }
    else {
      _parameters = parameters.dup;
    }
	}

	char[] name() {
		return _name.dup;
	}

  TypeNode type() {
    return _type;
  }

	VariableDeclarationNode[] parameters() {
    if (_parameters is null) {
      return null;
    }
		return _parameters.dup;
	}
}
