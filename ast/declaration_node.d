module ast.declaration_node;

class DeclarationNode {
public:

	enum Type {
		ClassDeclaration,
		ConstructorDeclaration,
		DestructorDeclaration,
		EnumDeclaration,
		FunctionDeclaration,
		ImportDeclaration,
		InterfaceDeclaration
	}

private:
	Type   _type;
	Object _node;

public:

	this(Type type, Object node) {
		_type = type;
		_node = node;
	}

	Type type() {
		return _type;
	}

	Object node() {
		return _node;
	}
}
