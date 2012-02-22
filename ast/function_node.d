module ast.function_node;

import ast.statement_node;
import ast.variable_declaration_node;

class FunctionNode {
private:
	char[]                    _name;
	StatementNode[]           _bodyBlock;
	StatementNode[]           _inBlock;
	StatementNode[]           _outBlock;
	VariableDeclarationNode[] _params;

public:
	this(char[] name,
		 VariableDeclarationNode[] params,
	     StatementNode[] bodyBlock,
	     StatementNode[] inBlock,
		 StatementNode[] outBlock) {

		_name = name.dup;
		_bodyBlock = bodyBlock.dup;
		_inBlock = inBlock.dup;
		_outBlock = outBlock.dup;
		_params = params.dup;
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

	VariableDeclarationNode[] parameters() {
		return _params.dup;
	}
}
