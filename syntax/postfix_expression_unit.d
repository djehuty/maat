/*
 * postfix_expression_unit.d
 *
 */

module syntax.postfix_expression_unit;

import lex.lexer;
import lex.token;
import logger;

import syntax.primary_expression_unit;
import syntax.index_or_slice_expression_unit;
import syntax.argument_list_unit;

/*


*/

class PostfixExpressionUnit {
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
        if (_state == 1) {
          // Disambiguate between index and slice expression
          auto expr = (new IndexOrSliceExpressionUnit(_lexer, _logger)).parse;
        }
        else {
          goto default;
        }

        break;

      case Token.Type.Identifier:
        if (_state == 2) {
          _state = 1;
        }
        else if (_state == 1) {
          // Error: Expect a dot, not an identifier.
        }
        else if (_state == 0) {
          goto default;
        }
        break;

      case Token.Type.Dot:
        if (_state == 1) {
          _state = 2;
        }
        else if (_state == 0) {
          goto default;
        }
        break;

      case Token.Type.Decrement:
        if (_state == 1) {
          // Done.
          return false;
        }
        goto default;

      case Token.Type.Increment:
        if (_state == 1) {
          // Done.
          return false;
        }
        goto default;

      case Token.Type.LeftParen:
        if (_state == 1) {
          auto args = (new ArgumentListUnit(_lexer, _logger)).parse;
          _state = 1;
          break;
        }
        goto default;

			default:
				_lexer.push(token);
        if (_state == 1) {
          // Done.
          return false;
        }
				auto expr = (new PrimaryExpressionUnit(_lexer, _logger)).parse;
        _state = 1;
				break;
		}

		return true;
	}
}
