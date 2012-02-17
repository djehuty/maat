/*
 * foreach_statement_unit.d
 *
 */

module syntax.foreach_statement_unit;

import syntax.scoped_statement_unit;
import syntax.expression_unit;
import syntax.type_unit;

import lex.lexer;
import lex.token;
import logger;

/*

	foreach | foreach_reverse
	ForeachStmt => ( ForeachTypeList ; Expression ) ScopeStmt
	             | ( ForeachTypeList ; Tuple ) ScopeStmt

	ForeachTypeList => ForeachType , ForeachTypeList
	                 | ForeachType

	ForeachType => ref Type Identifier
	             | Type Identifier
	             | ref Identifier
	             | Identifier

*/

class ForeachStatementUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	char[] parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

		return "";
	}

	bool tokenFound(Token token) {
		switch (token.type) {
			case Token.Type.LeftParen:
				if (_state > 0) {
					// Error: Already found left parenthesis.
					// TODO:
				}
				_state = 1;
				break;
			case Token.Type.RightParen:
				if (_state != 5) {
				}
				auto stmt = (new ScopedStatementUnit(_lexer, _logger)).parse;
				return false;
			case Token.Type.Ref:
				if (_state == 0) {
				}
				else if (_state >= 2) {
				}
				_state = 2;
				break;
			case Token.Type.Identifier:
				if (_state == 0) {
				}
				if (_state > 3) {
				}
				if (_state == 3) {
					_state = 4;
				}
				else {
					// This needs lookahead to know it isn't a type
					Token foo = _lexer.pop();
					_lexer.push(foo);
					if (foo.type == Token.Type.Comma || foo.type == Token.Type.Semicolon) {
						_state = 4;
					}
					else {
						_lexer.push(token);
	
						// Getting type of identifier
						auto type = (new TypeUnit(_lexer, _logger)).parse;
	
						_state = 3;
					}
				}

				if (_state == 4) {
				}
				break;
			case Token.Type.Semicolon:
				if (_state < 4) {
				}
				auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
				_state = 5;
				break;
			case Token.Type.Comma:
				if (_state != 4) {
				}
				_state = 1;
				break;
			default:
				break;
		}
		return true;
	}
}
