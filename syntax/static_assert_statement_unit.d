/*
 * static_assert_statement_unit.d
 *
 */

module syntax.static_assert_statement_unit;

import syntax.assign_expression_unit;

import ast.declaration_node;

import lex.lexer;
import lex.token;
import logger;

/*

  static assert
  StaticAssertStatement = assert ( AssignExpression , AssignExpression )
                        | assert ( AssignExpression )
                        
*/

class StaticAssertStatementUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	DeclarationNode parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

		return null;
	}

	bool tokenFound(Token token) {
		switch (token.type) {
      case Token.Type.LeftParen:
        if (_state == 0) {
          auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
          _state = 1;
        }
        else {
          // Error: TODO
        }
        break;

      case Token.Type.Comma:
        if (_state == 1) {
          // Good
          auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
          _state = 2;
        }
        else if (_state == 0) {
        }
        else if (_state == 2) {
        }
        break;

      case Token.Type.RightParen:
        if (_state == 1 || _state == 2) {
          // Done.
          return false;
        }
        else {
        }
        break;

			default:
				break;
		}

		return true;
	}
}
