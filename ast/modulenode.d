module ast.modulenode;

import ast.declarationnode;

class ModuleNode {
private:
	char[] _name;
	DeclarationNode[] _declarations;

public:
	this(char[] name, DeclarationNode[] declarations) {
		_name = name.dup;
		_declarations = declarations;
	}

	char[] name() {
		return _name.dup;
	}

	DeclarationNode[] declarations() {
		return _declarations;
	}
}
