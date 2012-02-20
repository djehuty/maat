module ast.function_node;

import ast.statement_node;

class FunctionNode {
private:
	StatementNode[] _bodyBlock;
	StatementNode[] _inBlock;
	StatementNode[] _outBlock;

public:
	this(StatementNode[] bodyBlock,
	     StatementNode[] inBlock,
		 StatementNode[] outBlock) {
		_bodyBlock = bodyBlock.dup;
		_inBlock = inBlock.dup;
		_outBlock = outBlock.dup;
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
