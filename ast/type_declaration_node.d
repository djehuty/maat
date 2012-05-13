module ast.type_declaration_node;

import ast.function_node;
import ast.variable_declaration_node;

class TypeDeclarationNode {
public:
	enum Type {
		FunctionDeclaration,
    VariableDeclaration
	}

private:
	Type   _type;
	Object _node;

public:
	this(FunctionNode functionNode) {
		_type = Type.FunctionDeclaration;
		_node = functionNode;
	}

  this(VariableDeclarationNode variableNode) {
    _type = Type.VariableDeclaration;
    _node = variableNode;
  }

	Type type() {
		return _type;
	}

	Object node() {
		return _node;
	}
}
