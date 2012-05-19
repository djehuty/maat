/*
 * while_statement_unit.d
 *
 */

module syntax.while_statement_unit;

import syntax.scoped_statement_unit;
import syntax.statement_unit;
import syntax.block_statement_unit;
import syntax.expression_unit;

import lex.lexer;
import lex.token;
import logger;

/*

  while
  WhileStatement = ( Expression ) ScopedStatement

*/

class WhileStatementUnit {
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
        if (_state == 0) {
          auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
          _state = 1;
        }
        else {
          goto default;
        }
        break;
       
      case Token.Type.RightParen:
        if (_state == 1) {
          // Good
          auto stmts = (new ScopedStatementUnit(_lexer, _logger)).parse;
          return false;
        }
      default:
        // Error
        return false;
    }

		return true;
	}
}
