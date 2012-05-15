/*
 * array_literal_unit.d
 *
 */

module syntax.array_literal_unit;

import syntax.assign_expression_unit;

import lex.lexer;
import lex.token;
import logger;

/*
  [
  ArrayLiteralUnit = AssignExpression , ArrayLiteralUnit
                   | ]
*/

class ArrayLiteralUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

	static const char[][] _common_error_usages = [
    "[]", "[0, 1, 2]", "[0, 2 + 2, foo()]"];

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
      case Token.Type.RightBracket:
        if (_state == 2) {
          // Error: Saw comma. Require expression
          _logger.error(_lexer, token,
              "This array literal is missing a value before a closing bracket.",
              "The last value may not be followed by a comma. Did you mean to remove it?",
              _common_error_usages);
        }

        // Done
        return false;
      case Token.Type.Comma:
        if (_state == 0) {
          // Error. Have not seen any expressions
          _logger.error(_lexer, token,
              "Array literal is malformed due to an unexpected comma.",
              "This array literal should start with a value.",
              _common_error_usages);
        }
        else if (_state == 1) {
          // Have seen an expression
          _state = 2;
        }
      default:
        // AssignExpression
        if (_state == 0 || _state == 2) {
          auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
          _state = 1;
        }
        else {
          // Error: Did not see a comma.
          _logger.error(_lexer, token,
              "Array literal is malformed due to multiple expressions given.",
              "Did you mean to place a comma here?",
              _common_error_usages);
          return false;
        }
        break;
		}

		return true;
	}
}
