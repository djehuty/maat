/*
 * new_expression_unit.d
 *
 */

module syntax.new_expression_unit;

import lex.lexer;
import lex.token;
import logger;

import syntax.assign_expression_unit;
import syntax.type_unit;

/*

  new
  NewExpression = ( ArgumentList? )? Type [ AssignExpression ]
                | ( ArgumentList? )? Type ( ArgumentList )
                | ( ArgumentList? )? Type
                | NewAnonymousClassExpression

  ArgumentList = AssignExpression
               | AssignExpression , ArgumentList

*/

class NewExpressionUnit {
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
		if (token.type == Token.Type.Comment) {
			return true;
		}

		switch (token.type) {
      case Token.Type.LeftBracket:
        if (_state == 5) {
          // Good.
          _state = 9;
        }
        break;

      case Token.Type.RightBracket:
        if (_state == 10) {
          // Done.
          return false;
        }
        break;

      case Token.Type.LeftParen:
        if (_state == 0) {
          _state = 1;
        }
        else if (_state == 1 || _state == 3) {
          // Fall through
          goto default;
        }
        else if (_state == 2) {
          // Error: Expected comma or right paren. Got a second expression (potentially.)
        }
        else if (_state == 4) {
          // Error: Expected type. Got an expression (potentially.)
        }
        else if (_state == 5) {
          // ArgumentList start
          _state = 6;
        }

        break;

      case Token.Type.Comma:
        if (_state == 2) {
          _state = 3;
        }
        else if (_state == 7) {
          _state = 8;
        }
        break;

      case Token.Type.RightParen:
        if (_state == 3) {
          // Error: Saw comma, expected expression.
        }
        else if (_state == 1 || _state == 2) {
          // Good
          _state = 4;
        }
        else if (_state == 6 || _state == 7) {
          // Done.
          return false;
        }
        break;

			default:
				_lexer.push(token);
				if (_state == 1 || _state == 3) {
          auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
          _state = 2;
				}
        else if (_state == 0 || _state == 4) {
          auto type = (new TypeUnit(_lexer, _logger)).parse;
          _state = 5;
        }
        else if (_state == 5) {
          // Done
          return false;
        }
        else if (_state == 6 || _state == 8) {
          auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
          _state = 7;
        }
        else if (_state == 9) {
          auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
          _state = 10;
        }
				break;
		}

		return true;
	}
}
