module ast.function_node;

import ast.statement_node;
import ast.variable_declaration_node;
import ast.type_node;

class FunctionNode {
private:
	char[]                    _name;
	StatementNode[]           _bodyBlock;
	StatementNode[]           _inBlock;
	StatementNode[]           _outBlock;
	VariableDeclarationNode[] _params;
  TypeNode                  _returnType;
	char[]                    _comment;

public:
	this(char[] name,
       TypeNode returnType,
       VariableDeclarationNode[] params,
       StatementNode[] bodyBlock,
       StatementNode[] inBlock,
       StatementNode[] outBlock,
       char[]          comment = null) {

    _name = name.dup;
    _bodyBlock = bodyBlock.dup;
    _inBlock = inBlock.dup;
    _outBlock = outBlock.dup;
    _params = params.dup;
    _comment = comment.dup;
    _returnType = returnType;
  }

  char[] name() {
    return _name.dup;
  }

  TypeNode returnType() {
    return _returnType;
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

  char[] comment() {
    return _comment.dup;
  }
}
