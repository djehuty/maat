module ast.module_node;

import ast.declaration_node;

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

	DeclarationNode[] imports() {
		if (_declarations is null) {
			return null;
		}

		DeclarationNode[] ret = [];
		foreach(node; _declarations) {
			if (node.type == DeclarationNode.Type.ImportDeclaration) {
				ret ~= node;
			}
		}
		return ret;
	}
}
