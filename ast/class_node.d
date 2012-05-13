module ast.class_node;

import ast.function_node;

class ClassNode {
private:
	FunctionNode[] _constructors;
	FunctionNode[] _methods;
	FunctionNode   _destructor;
	char[]         _name;
	char[]         _comment;

public:
	this(char[] name,
	     FunctionNode[] constructors,
	     FunctionNode destructor,
	     FunctionNode[] methods,
	     char[] comment = null) {

		_constructors = constructors.dup;
		_destructor   = destructor;
		_methods      = methods.dup;
		_name         = name.dup;
		_comment      = comment.dup;
	}

	char[] name() {
		return _name.dup;
	}

	char[] comment() {
		return _comment.dup;
	}

	FunctionNode[] methods() {
		return _methods.dup;
	}
	
	FunctionNode[] constructors() {
		return _constructors.dup;
	}

	FunctionNode destructor() {
		return _destructor;
	}
}
