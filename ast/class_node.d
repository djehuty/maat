module ast.class_node;

import ast.function_node;

class ClassNode {
private:
	FunctionNode[] _constructors;
	FunctionNode[] _methods;
	FunctionNode   _destructor;

public:
	this(FunctionNode[] constructors, FunctionNode destructor, FunctionNode[] methods) {
		_constructors = constructors.dup;
		_destructor   = destructor;
		_methods      = methods.dup;
	}
}
