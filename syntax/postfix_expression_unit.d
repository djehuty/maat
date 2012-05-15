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
