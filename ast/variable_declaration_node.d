module ast.variable_declaration_node;

import ast.type_node;
import ast.expression_node;

class VariableDeclarationNode {
private:
	char[]         _name;
	TypeNode       _type;
	ExpressionNode _initialValue;

public:
	this(char[] name, TypeNode type, ExpressionNode initialValue) {
		_initialValue = initialValue;
		_name         = name;
		_type         = type;
	}

	char[] name() {
		return _name;
	}

	TypeNode type() {
		return _type;
	}

	ExpressionNode initialValue() {
		return _initialValue;
	}
}
