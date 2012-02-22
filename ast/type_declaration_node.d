module ast.type_declaration_node;

import ast.function_node;

class TypeDeclarationNode {
public:
	enum Type {
		FunctionDeclaration
	}

private:
	Type   _type;
	Object _node;

public:
	this(FunctionNode functionNode) {
		_type = Type.FunctionDeclaration;
		_node = functionNode;
	}

	Type type() {
		return _type;
	}

	Object node() {
		return _node;
	}
}
