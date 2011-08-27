module syntax.trees;

import syntax.ast;

class Import : AbstractSyntaxTree {
	this(char[] packageName) {
		_packageName = packageName;
	}

	char[] packageName() {
		return _packageName;
	}

protected:
	char[] _packageName;
}
