/*
 * try_statement_unit.d
 *
 */

module syntax.try_statement_unit;

import syntax.scoped_statement_unit;
import syntax.block_statement_unit;
import syntax.basic_type_unit;

import lex.lexer;
import lex.token;
import logger;

/*

  try
  TryStatementUnit = ScopedStatement CatchStatements
                   | ScopedStatement CatchStatements finally FinallyStatement
                   | ScopedStatement finally FinallyStatement

  CatchStatements = catch CatchStatement CatchStatements
                  | catch CatchStatement
                  | catch LastCatchStatement

  catch
  CatchStatement = ( BasicType Identifier ) BlockStatement
                 | ( BasicType Identifier ) NonEmptyStatement

  catch
  LastCatchStatement = BlockStatement
                     | NonEmptyStatement

  finally
  FinallyStatement = BlockStatement
                   | NonEmptyStatement


*/

class TryStatementUnit {
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
      case Token.Type.Catch:
        if (_state == 1) {
          _state = 2;
        }
        break;

      case Token.Type.LeftParen:
        if (_state == 2) {
          // Catch parameter
          _state = 3;
          break;
        }

        goto default;

      case Token.Type.RightParen:
        if (_state == 5) {
          // Good.
          _state = 6;
        }
        break;

      case Token.Type.LeftCurly:
        if (_state == 2 || _state == 6) {
          auto catch_stmts = (new BlockStatementUnit(_lexer, _logger)).parse;
          _state = 1;
          break;
        }
        else if (_state == 7) {
          auto finally_stmts = (new BlockStatementUnit(_lexer, _logger)).parse;
          // Done.
          return false;
        }

        goto default;

      case Token.Type.Finally:
        if (_state == 1) {
          _state = 7;
        }
        break;

      case Token.Type.Identifier:
        if (_state == 4) {
          // Catch parameter name
          _state = 5;
          break;
        }

        goto default;

			default:
        _lexer.push(token);

        if (_state == 0) {
          auto stmts = (new ScopedStatementUnit(_lexer, _logger)).parse;
          _state = 1;
        }
        else if (_state == 3) {
          // Basic Type?
          auto basic_type = (new BasicTypeUnit(_lexer, _logger)).parse;
          _state = 4;
        }
        else {
          // Done.
          return false;
        }

				break;
		}
		return true;
	}
}
