/*
 * constructor_declaration_unit.d
 *
 */

module syntax.constructor_declaration_unit;

import syntax.parameter_list_unit;
import syntax.function_body_unit;

import ast.function_node;

import lex.lexer;
import lex.token;
import logger;

import tango.io.Stdout;

class ConstructorDeclarationUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

	FunctionNode _functionNode;

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	FunctionNode parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

		return _functionNode;
	}

	bool tokenFound(Token token) {
		switch (token.type) {
			// First, we look for the left paren of the parameter list
			case Token.Type.LeftParen:
				if (_state != 0) {
					// It should be the first thing!
					// Error: Too many left parentheses!
				}
				_state = 1;
				break;

			// After finding a left paren, look for a right one
			case Token.Type.RightParen:
				if (_state == 0) {
					// Error: No left paren found before this right one!
					// TODO:
				}
				else if (_state != 1) {
					// Error: Already parsed a right paren! We have too many right parens!
					// TODO:
				}
				_state = 2;
				break;

			// Look for the end of a bodyless declaration
			case Token.Type.Semicolon:
				if (_state == 0) {
					// Error: Have not found a left paren!
					// TODO:
				}
				if (_state != 2) {
					// Error: Have not found a right paren!
					// TODO:
				}
				Stdout("Constructor without body.").newline;
				_functionNode = new FunctionNode(null, null, null, null);
				// Done.
				return false;

			// Function body
			case Token.Type.In:
			case Token.Type.Out:
			case Token.Type.Body:
			case Token.Type.LeftCurly:
				// Have we found a parameter list?
				if (_state == 0) {
					// Error: No parameter list given at all
					// TODO:
				}
				else if (_state == 1) {
					// Error: We have a left parenthesis... but no right one
					// TODO:
				}
				else if (_state != 2) {
					// Error: No parameter list
					// TODO:
				}

				// Function body!
				_lexer.push(token);
				auto functionBody = (new FunctionBodyUnit(_lexer, _logger)).parse;
				_functionNode = new FunctionNode(null, null, null, null);

				// Done.
				return false;

			// Otherwise, we might have found something that is in the parameter list
			default:
				if (_state == 1) {
					// Found a left paren, but not a right paren...
					// Look for the parameter list.
					_lexer.push(token);
					auto params = (new ParameterListUnit(_lexer, _logger)).parse;
				}
				else {
					// Errors!
					if (_state == 0) {
						// Error this BLEH...Need parameters!
						// TODO:
					}
					else if (_state == 2) {
						// Error: this(...) BLEH... Need function body or semicolon!
						// TODO:
					}
				}
				break;
		}
		return true;
	}
}

