/*
 * cast_expression_unit.d
 *
 */

module syntax.cast_expression_unit;

import syntax.unary_expression_unit;
import syntax.type_unit;

import lex.lexer;
import lex.token;
import logger;

/*

  cast
  CastExpression = ( Type ) UnaryExpression

*/

class CastExpressionUnit {
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
      case Token.Type.LeftParen:
        if (_state == 0) {
          _state = 1;
        }

        break;

      case Token.Type.RightParen:
        if (_state == 0) {
          // Error: Did not see a (
          _logger.error(_lexer, token,
              "Cast has a malformed type specification.",
              "Did you mean to place a '(' here?",
              ["cast(int)5", "cast(Object)foo", "cast(typeof(5))42"]);
          return false;
        }

        if (_state == 1) {
          // Error: No type specification.
          _logger.error(_lexer, token,
              "Cast must provide a type specification to indicate the type to yield.",
              "Place a type within the parentheses.",
              ["cast(int)5", "cast(Object)foo", "cast(typeof(5))42"]);
          return false;
        }

        auto expr = (new UnaryExpressionUnit(_lexer, _logger)).parse;
        return false;

			default:
				_lexer.push(token);
				if (_state == 1) {
          auto type = (new TypeUnit(_lexer, _logger)).parse;
        }
        else if (_state == 0) {
          // Error: Did not see a (
          _logger.error(_lexer, token,
              "Cast must be given a type within parentheses.",
              "Place a type after the cast token.",
              ["cast(int)5", "cast(Object)foo", "cast(typeof(5))42"]);
        }
        else if (_state == 2) {
          _logger.error(_lexer, token,
              "Cast type specification is malformed.",
              "Did you intend to place a ')' here?",
              ["cast(int)5", "cast(Object)foo", "cast(typeof(5))42"]);
        }

				_state = 2;
				break;
		}

		return true;
	}
}
