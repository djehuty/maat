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
	FunctionNode[] _constructors;
	FunctionNode   _destructor;

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

		return [_constructors, [_destructor], _functions];
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

      case Token.Type.Public:
        break;
      case Token.Type.Private:
        break;
      case Token.Type.Static:
        break;
      case Token.Type.Final:
        break;
      case Token.Type.Protected:
        break;
      case Token.Type.Colon:
        break;

			// Otherwise, it must be some Declarator
			default:
				_lexer.push(token);
				auto decl = (new DeclarationUnit(_lexer, _logger)).parse;
				if (decl.type == DeclarationNode.Type.FunctionDeclaration) {
					_functions ~= cast(FunctionNode)decl.node;
				}
				else if (decl.type == DeclarationNode.Type.ConstructorDeclaration) {
					_constructors ~= cast(FunctionNode)decl.node;
				}
				else if (decl.type == DeclarationNode.Type.DestructorDeclaration) {
					if (_destructor is null) {
						_destructor = cast(FunctionNode)decl.node;
					}
					else {
						// XXX: Error. Two destructors.
					}
				}
				break;
		}
		return true;
	}
}
