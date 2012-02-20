module ast.function_node;

import ast.statement_node;

class FunctionNode {
private:
	char[] _name;
	StatementNode[] _bodyBlock;
	StatementNode[] _inBlock;
	StatementNode[] _outBlock;

public:
	this(char[] name,
	     StatementNode[] bodyBlock,
	     StatementNode[] inBlock,
		 StatementNode[] outBlock) {

		_name = name.dup;
		_bodyBlock = bodyBlock.dup;
		_inBlock = inBlock.dup;
		_outBlock = outBlock.dup;
	}

	char[] name() {
		return _name.dup;
	}

	StatementNode[] bodyBlock() {
		return _bodyBlock.dup;
	}

	StatementNode[] inBlock() {
		return _inBlock.dup;
	}

	StatementNode[] outBlock() {
		return _outBlock.dup;
	}
}
