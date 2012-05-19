/*
 * template_argument_list_unit.d
 *
 */

module syntax.template_argument_list_unit;

import syntax.assign_expression_unit;

import lex.lexer;
import lex.token;
import logger;

/*

  TemplateArgumentList = ( TemplateArguments )

  TemplateArguments = TemplateArgument
                    | TemplateArgument , TemplateArgumentList

  TemplateArgument = Type
                   | AssignExpression

*/

class TemplateArgumentListUnit {
private:
	Lexer  _lexer;
	Logger _logger;

  enum State {
    LookingForLeftParen,
    TemplateArguments,
    LookingForRightParen,
  }

	State _state;

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
      case Token.Type.LeftParen:
        if (_state == State.LookingForLeftParen) {
          _state = State.TemplateArguments;
        }
        goto default;

      case Token.Type.RightParen:
        if (_state == State.LookingForRightParen) {
          // Done.
          return false;
        }
        else if (_state == State.LookingForLeftParen) {
          // Error: Expect left paren.
          return false;
        }
        goto default;

      case Token.Type.Comma:
        if (_state == State.LookingForRightParen) {
          _state = State.TemplateArguments;
        }
        else {
          // Error: Expecting expression, not comma
          return false;
        }

        break;

      default:
        if (_state == State.LookingForLeftParen) {
          // Error: Expect left paren.
          return false;
        }
        else if (_state == State.LookingForRightParen) {
          // Error: Expecting right paren or comma.
          return false;
        }

        auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
        _state = State.LookingForRightParen;
        break;
		}

		return true;
	}
}
