/*
 * primary_expression_unit.d
 *
 */

module syntax.primary_expression_unit;

import syntax.function_literal_expression_disambiguation_unit;
import syntax.function_literal_unit;
import syntax.array_literal_disambiguation_unit;
import syntax.array_literal_unit;
import syntax.expression_unit;
import syntax.template_argument_list_unit;

import lex.lexer;
import lex.token;
import logger;

/*

*/

class PrimaryExpressionUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

	char[] _cur_string;

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

    if (_state == 3) {
      if (token.type == Token.Type.Bang) {
        // Template Argument List
        auto templateList = (new TemplateArgumentListUnit(_lexer, _logger)).parse;
        // Done.
        return false;
      }
      else {
        // Done.
        _lexer.push(token);
        return false;
      }
    }

		switch (token.type) {
			case Token.Type.StringLiteral:
      case Token.Type.CharacterLiteral:
        if (_state == 1) {
          // Error:
          return false;
        }
				_cur_string = token.string;
				return false;

			case Token.Type.IntegerLiteral:
        if (_state == 1) {
          // Error:
          return false;
        }
				return false;

			case Token.Type.Identifier:
        _state = 3;
        return true;

      case Token.Type.This:
        if (_state == 1) {
          // Error:
          return false;
        }
        return false;

      case Token.Type.Null:
        if (_state == 1) {
          // Error:
          return false;
        }
        return false;

      case Token.Type.True:
        if (_state == 1) {
          // Error:
          return false;
        }
        return false;

      case Token.Type.False:
        if (_state == 1) {
          // Error:
          return false;
        }
        return false;

      case Token.Type.Dollar:
        if (_state == 1) {
          // Error:
          return false;
        }
        return false;

      case Token.Type.Super:
        if (_state == 1) {
          // Error:
          return false;
        }
        return false;

      case Token.Type.Dot:
        _state = 1;
        return true;

      case Token.Type.LeftBracket:
        // Disambiguate between different array literal types:
        auto arrayType = (new ArrayLiteralDisambiguationUnit(_lexer, _logger)).parse;
        if (arrayType == ArrayLiteralDisambiguationUnit.ArrayLiteralVariant.Array) {
          auto array = (new ArrayLiteralUnit(_lexer, _logger)).parse;
        }
        return false;

      case Token.Type.LeftParen:
        if (_state == 2) {
          // Error: Unexpected left parentheses.
          return false;
        }

        auto isFunctionLiteral = (new FunctionLiteralExpressionDisambiguationUnit(_lexer, _logger)).parse;

        if (isFunctionLiteral == FunctionLiteralExpressionDisambiguationUnit.ExpressionVariant.FunctionLiteral) {
          _lexer.push(token);
          auto expr = (new FunctionLiteralUnit(_lexer, _logger)).parse;
          return false;
        }

        auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
        _state = 2;
        return true;

      case Token.Type.RightParen:
        if (_state == 2) {
          // Good
          return false;
        }
        else {
          // Maybe the close of the last expression? Let's throw it back.
          // Whichever the case, we are Done here.
          _lexer.push(token);
          return false;
        }
        break;

      case Token.Type.Function:
      case Token.Type.Delegate:
      case Token.Type.Body:
      case Token.Type.In:
      case Token.Type.Out:
      case Token.Type.LeftCurly:
        _lexer.push(token);
        auto expr = (new FunctionLiteralUnit(_lexer, _logger)).parse;
        return false;

			default:
				break;
		}
		return false;
	}
}
