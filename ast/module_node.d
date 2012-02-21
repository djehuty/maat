module ast.module_node;

import ast.declaration_node;
import ast.import_declaration_node;

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

	ImportDeclarationNode[] imports() {
		ImportDeclarationNode[] ret = [];
		foreach(decl; _declarations) {
			if (decl.type == DeclarationNode.Type.ImportDeclaration) {
				ret ~= cast(ImportDeclarationNode)decl.node;
			}
		}
		return ret;
	}
}
