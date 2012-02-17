module ast.if_node;

import ast.expression_node;
import ast.block_node;

class IfNode {
private:
	ExpressionNode _expression;
	BlockNode _trueBlock;
	BlockNode _falseBlock;

public:

	this(ExpressionNode e, BlockNode trueBlock, BlockNode falseBlock) {
		_expression = e;
		_trueBlock = trueBlock;
		_falseBlock = falseBlock;
	}

	ExpressionNode expression() {
		return _expression;
	}

	BlockNode trueBlock() {
		return _trueBlock;
	}

	BlockNode falseBlock() {
		return _falseBlock;
	}
}
