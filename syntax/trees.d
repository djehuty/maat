module syntax.trees;

import syntax.ast;

class Import : AbstractSyntaxTree {
	this(string packageName) {
		Console.putln("Import: ", packageName);
		_packageName = packageName;
	}

	string packageName() {
		return _packageName;
	}

protected:
	string _packageName;
}
