/*
 * argument_list_unit.d
 *
 */

module syntax.argument_list_unit;

import lex.lexer;
import lex.token;
import logger;

import syntax.assign_expression_unit;

/*

   (
   ArgumentList = Arguments )
                | )

   Arguments = AssignExpression
             | AssignExpression , Arguments

*/

class ArgumentListUnit {
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
      case Token.Type.RightParen:
        if (_state == 0 || _state == 1) {
          // Done.
          return false;
        }
        break;

      case Token.Type.Comma:
        if (_state == 1) {
          _state = 2;
        }
        else if (_state == 0) {
          // Error: Comma is before first argument
          return false;
        }
        else if (_state == 2) {
          // Error: Comma follows a comma. Argument perhaps omitted.
          return false;
        }
        break;

      default:
        _lexer.push(token);
        if (_state == 0 || _state == 2) {
          auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
          _state = 1;
        }
        else if (_state == 1) {
          // Error: Comma or right paren expected
          return false;
        }
        break;
		}

		return true;
	}
}
