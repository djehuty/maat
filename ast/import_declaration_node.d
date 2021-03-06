module ast.import_declaration_node;

class ImportDeclarationNode {
private:
	char[] _moduleName;

public:
	this(char[] moduleName) {
		_moduleName = moduleName.dup;
	}

	char[] moduleName() {
		return _moduleName.dup;
	}
}
