module ast.declarator_node;

class DeclaratorNode {
private:
	char[] _name;

public:
	this(char[] name) {
		_name = name.dup;
	}

	char[] name() {
		return _name.dup;
	}
}
