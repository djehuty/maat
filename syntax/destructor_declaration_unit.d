/*
 * destructor_declaration_unit.d
 *
 */

module syntax.destructor_declaration_unit;

import syntax.function_body_unit;

import ast.function_node;

import lex.lexer;
import lex.token;
import logger;

class DestructorDeclarationUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

	bool   _thisFound = false;

	FunctionNode _functionNode;

	static const char[] _common_error_msg = "Destructor declaration invalid.";
	static const char[][] _common_error_usages = [
		"~this() { }",
		"~this();"
	];

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
				if (!_thisFound) {
					// Error: Need this after ~
					_logger.error(_lexer, token, _common_error_msg,
							"Did you intend on having a destructor here? You are missing 'this'.",
							_common_error_usages);
				}
				else if (_state != 0) {
					// It should be the first thing!
					// Error: Too many left parentheses!
					_logger.error(_lexer, token, _common_error_msg,
							"You accidentally placed too many left parentheses here.",
							_common_error_usages);
				}
				_state = 1;
				break;

				// After finding a left paren, look for a right one
			case Token.Type.RightParen:
				if (!_thisFound) {
					// Error: Need this after ~
					_logger.error(_lexer, token, _common_error_msg,
							null,
							_common_error_usages);
				}
				else if (_state == 0) {
					// Error: No left paren found before this right one!
					_logger.error(_lexer, token, _common_error_msg,
							"You are missing a left parenthesis.",
							_common_error_usages);
				}
				else if (_state != 1) {
					// Error: Already parsed a right paren! We have too many right parens!
					_logger.error(_lexer, token, _common_error_msg,
							"You have placed too many right parentheses.",
							_common_error_usages);
				}
				_state = 2;
				break;

				// Look for the end of a bodyless declaration
			case Token.Type.Semicolon:
				if (!_thisFound) {
					// Error: Need this after ~
					_logger.error(_lexer, token, _common_error_msg,
							"A '~' does nothing on its own.",
							_common_error_usages);
				}
				else if (_state == 0) {
					// Error: Have not found a left paren!
					_logger.error(_lexer, token, _common_error_msg,
							"You must have a empty parameter list for your destructor.",
							_common_error_usages);
				}
				else if (_state != 2) {
					// Error: Have not found a right paren!
					_logger.error(_lexer, token, _common_error_msg,
							"You accidentally left out a right parenthesis.",
							_common_error_usages);
				}
				// Done.
				_functionNode = new FunctionNode(null, null, null, null, null, null);
				return false;

				// Function body
			case Token.Type.In:
			case Token.Type.Out:
			case Token.Type.Body:
			case Token.Type.LeftCurly:
				// Have we found a parameter list?
				if (!_thisFound) {
					// Error: Need this after ~
					_logger.error(_lexer, token, _common_error_msg,
							null,
							_common_error_usages);
				}
				else if (_state == 0 ) {
					// Error: No parameter list given at all
					_logger.error(_lexer, token, _common_error_msg,
							"You must have an empty parameter list for a destructor.",
							_common_error_usages);
				}
				else if (_state == 1) {
					// Error: We have a left parenthesis... but no right one
					_logger.error(_lexer, token, _common_error_msg,
							"You have accidentally left out a right parenthesis.",
							_common_error_usages);
				}

				// Function body!
				_lexer.push(token);
				auto destructor_body = (new FunctionBodyUnit(_lexer, _logger)).parse;
				_functionNode = new FunctionNode(null, null, null, null, null, null);

				// Done.
				return false;

				// We are only given that the first token, ~, is found...
				// So, we must ensure that the This keyword is the first item
			case Token.Type.This:
				if (_state == 0 && !_thisFound) {
					_thisFound = true;
				}
				else if (_state == 0 && _thisFound) {
					// Error: this this <- listed twice in a row
					_logger.error(_lexer, token, _common_error_msg,
							"You accidentally placed two 'this' in a row.",
							_common_error_usages);
				}
				else if (_state == 1) {
					// Error: Expected right paren, got this.
					_logger.error(_lexer, token, _common_error_msg,
							"The parameter list should be empty for a destructor.",
							_common_error_usages);
				}
				else { 
					// Error: Got this, expected function body or ;
					_logger.error(_lexer, token, _common_error_msg,
							"You probably forgot a semicolon.",
							_common_error_usages);
				}
				break;

				// All other tokens are errors.
			default:
				if (!_thisFound) {
					// Error: Need this after ~
					_logger.error(_lexer, token, _common_error_msg,
							"A '~' character is unexpected here.",
							_common_error_usages);
				}
				else if (_state == 0) {
					// Error this BLEH...Need ()
					_logger.error(_lexer, token, _common_error_msg,
							"The destructor must have an empty parameter list: ~this ()",
							_common_error_usages);
				}
				else if (_state == 1) {
					// Error: Expected right paren
					_logger.error(_lexer, token, _common_error_msg,
							"The destructor must have an empty parameter list: ~this ()",
							_common_error_usages);
				}
				else if (_state == 2) {
					// Error: this(...) BLEH... Need function body or semicolon!
					_logger.error(_lexer, token, _common_error_msg,
							"You are probably missing a curly brace or a semicolon.",
							_common_error_usages);
				}				
				break;
		}
		return true;
	}
}
