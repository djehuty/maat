/*
 * do_statement_unit.d
 *
 */

module syntax.do_statement_unit;

import syntax.scoped_statement_unit;
import syntax.statement_unit;
import syntax.block_statement_unit;
import syntax.expression_unit;

import lex.lexer;
import lex.token;
import logger;

/*

  do
  DoStatement = ScopedStatement while ( Expression )

*/

class DoStatementUnit {
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
      case Token.Type.While:
        if (_state == 0) {
          // Error: Expected statement.
        }
        else if (_state == 1) {
          // Ok.
          _state = 2;
        }
        else {
          goto default;
        }
        break;

      case Token.Type.LeftParen:
        if (_state == 2) {
          // OK.
          // While expression follows.
          auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
          _state = 3;
        }
        else {
          goto default;
        }
        break;

      case Token.Type.RightParen:
        if (_state == 3) {
          // OK.
          _state = 4;
        }
        else {
          goto default;
        }
        break;

      case Token.Type.Semicolon:
        if (_state == 4) {
          // OK. Done.
          return false;
        }
        else {
          goto default;
        }
        break;

      default:
        _lexer.push(token);

        if (_state == 0) {
          auto stmt = (new ScopedStatementUnit(_lexer, _logger)).parse;
          _state = 1;
        }
        else {
          // Error.
          return false;
        }
    }

		return true;
	}
}
