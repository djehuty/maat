/*
 * if_statement_unit.d
 *
 */

module syntax.if_statement_unit;

import syntax.scoped_statement_unit;
import syntax.expression_unit;

import lex.lexer;
import lex.token;
import logger;

/*

	if
	IfStmt => ( IfCondition ) ScopeStatement ( else ScopeStatement )?

	IfCondition => Expression
	             | auto Identifier = Expression
				 | BasicType Declarator = Expression

*/

class IfStatementUnit {
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
		switch(_state) {
			case 0:
				switch (token.type) {
					case Token.Type.LeftParen:
						_state = 1;
						break;

					case Token.Type.RightParen:
					case Token.Type.Semicolon:
						// Bad
						break;

					default:
						break;
				}
				break;

			case 1: // IfCondition
				switch (token.type) {
					case Token.Type.Auto:
						_state = 2;
						break;
					default:
						// Expression
						_lexer.push(token);
						auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
						_state = 4;
						break;
				}
				break;
			case 2: // IfCondition: auto... Identifier = Expression
				switch (token.type) {
					case Token.Type.Identifier:
						_state = 3;
						break;
					default:
						// Bad
						break;
				}
				break;
			case 3: // IfCondition: auto Identifier... = Expression
				switch (token.type) {
					case Token.Type.Assign:
						auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
						_state = 4;
						break;
					default:
						// Bad
						break;
				}
				break;
			case 4: // IfCondition consumed
				switch (token.type) {
					case Token.Type.RightParen:
						// Good
						auto stmt = (new ScopedStatementUnit(_lexer, _logger)).parse;
						_state = 5;
						break;
					default:
						// Bad
						break;
				}
				break;
			case 5: // ( IfCondition ) ScopeStatement ... else ScopeStatement
				switch (token.type) {
					case Token.Type.Else:
						// Alright
						auto stmt = (new ScopedStatementUnit(_lexer, _logger)).parse;
						break;

					default:
						// Fine
						_lexer.push(token);
						break;
				}
				return false;
		}
		return true;
	}
}
