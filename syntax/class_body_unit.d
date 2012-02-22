/*
 * class_body_unit.d
 *
 */

module syntax.class_body_unit;

import syntax.declaration_unit;

import ast.class_node;
import ast.function_node;
import ast.declaration_node;

import lex.lexer;
import lex.token;
import logger;

class ClassBodyUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

	FunctionNode[] _functions;

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	FunctionNode[][] parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

		return [_functions, null, null];
	}

	bool tokenFound(Token token) {
		switch (token.type) {
			// We are always looking for the end of the body.
			case Token.Type.RightCurly:
				// Done.
				return false;

			// A new keyword will set up an allocator.
			case Token.Type.New:
				// TODO:
				break;

			// Ditto for a delete token for deallocator.
			case Token.Type.Delete:
				// TODO:
				break;

			// Otherwise, it must be some Declarator
			default:
				_lexer.push(token);
				auto decl = (new DeclarationUnit(_lexer, _logger)).parse;
				if (decl.type == DeclarationNode.Type.FunctionDeclaration) {
					_functions ~= cast(FunctionNode)decl.node;
				}
				break;
		}
		return true;
	}
}
