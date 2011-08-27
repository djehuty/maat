module syntax.trees;

import syntax.ast;

class Import : AbstractSyntaxTree {
	this(char[] packageName) {
		Console.putln("Import: ", packageName);
		_packageName = packageName;
	}

	char[] packageName() {
		return _packageName;
	}

protected:
	char[] _packageName;
}
