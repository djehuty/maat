/*
 * conditional_expression_unit.d
 *
 */

module syntax.conditional_expression_unit;

import lex.lexer;
import lex.token;
import logger;

import syntax.logical_or_expression_unit;

/*

   ConditionalExpr => LogicalOrExpr ? Expression : ConditionalExpr
                    | LogicalOrExpr

*/

class ConditionalExpressionUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

	static const char[][] _common_error_usages = [
    "x > 5 ? 0 : 1", "x <= 5 ? foo : bar"];

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
			return false;
		}

		switch (token.type) {
      case Token.Type.Question:
        if (_state == 1) {
          _state = 2;
          break;
        }
        else if (_state == 0) {
          // Question mark precedes expression
          _logger.error(_lexer, token,
              "Ternary operator is missing test expression.",
              "Did you forget to add a boolean expression to test with?",
              _common_error_usages);
        }
        else if (_state == 2) {
          // Two question marks
          _logger.error(_lexer, token,
              "Ternary operator has too many question marks.",
              "Did you accidentally add another question mark??",
              _common_error_usages);
        }
        else {
          // Question mark mishap
          _logger.error(_lexer, token,
              "Ternary operator is malformed.",
              "You seem to have misplaced this question mark.",
              _common_error_usages);
        }

        goto default;

      case Token.Type.Colon:
        if (_state == 3) {
          _state = 4;
          break;
        }
        else if (_state == 1) {
          // Expecting Question, got colon... not an error, but it means this is not a conditional
          _lexer.push(token);

          // Done.
          return false;
        }
        else if (_state == 2) {
          // No expression given
          _logger.error(_lexer, token,
              "Ternary operator is missing expression to yield on true.",
              "You seem to have forgotten to place a value here.",
              _common_error_usages);
        }
        else {
          // Colon is surprising!
          _lexer.push(token);
          return false;
        }

        goto default;

			default:
				_lexer.push(token);
				if (_state == 5) {
					// Done.
					return false;
				}

        if (_state == 1) {
          // Done.
          return false;
        }

        if (_state == 3) {
          // Looking for colon
          // Error
          _logger.error(_lexer, token,
              "Ternary operator is missing third operand.",
              "Did you mean to place a colon here?",
              _common_error_usages);
          return false;
        }
				auto tree = (new LogicalOrExpressionUnit(_lexer, _logger)).parse;

        _state++;
				break;
		}

		return true;
	}
}
