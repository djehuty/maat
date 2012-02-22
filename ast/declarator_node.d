module ast.declarator_node;

import ast.variable_declaration_node;

class DeclaratorNode {
private:
	char[] _name;

	VariableDeclarationNode[] _parameters;

public:
	this(char[] name, VariableDeclarationNode[] parameters) {
		_name = name.dup;
		_parameters = parameters.dup;
	}

	char[] name() {
		return _name.dup;
	}

	VariableDeclarationNode[] parameters() {
		return _parameters.dup;
	}
}
