/*
 * function_body_unit.d
 *
 */

module syntax.function_body_unit;

import syntax.block_statement_unit;

import ast.statement_node;

import lex.lexer;
import lex.token;
import logger;

class FunctionBodyUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	StatementNode[] parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

		return null;
	}

	bool tokenFound(Token token) {
		switch (token.type) {
			// We always look FIRST for a left curly brace
			case Token.Type.LeftCurly:
				auto stmt = (new BlockStatementUnit(_lexer, _logger)).parse;
				break;

			// TODO: in, out, body, block_statement foo
			case Token.Type.In:
				if (_state & 1 > 0) {
					// Bad (In already found)
				}
				if (_state & 4 > 0) {
					// Bad (Body already found)
				}
				_state = _state | 1;
				break;
			case Token.Type.Out:
				if (_state & 2 > 0) {
					// Bad (Out already found)
				}
				if (_state & 4 > 0) {
					// Bad (Body already found)
				}
				_state = _state | 2;
				break;
			case Token.Type.Body:
				_state = _state | 4;
				break;

			default:
				_lexer.push(token);
				return false;
		}
		return true;
	}
}
