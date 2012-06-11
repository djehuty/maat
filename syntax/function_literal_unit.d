/*
 * function_literal_unit.d
 *
 */

module syntax.function_literal_unit;

import syntax.function_body_unit;
import syntax.parameter_list_unit;
import syntax.type_unit;

import lex.lexer;
import lex.token;
import logger;

/*

  FunctionLiteral = ( ParameterList FunctionBody
                  | function Type FunctionBody
                  | delegate Type FunctionBody
                  | function Type ( ParameterList FunctionBody
                  | delegate Type ( ParameterList FunctionBody
                  | function FunctionBody
                  | delegate FunctionBody
                  | function ( ParameterList FunctionBody
                  | delegate ( ParameterList FunctionBody
                  | FunctionBody

*/

class FunctionLiteralUnit {
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
      case Token.Type.Function:
      case Token.Type.Delegate:
        if (_state == 0) {
          _state = 1;
          return true;
        }

        goto default;

      case Token.Type.LeftParen:
        if (_state == 0 || _state == 1 || _state == 2) {
          auto params = (new ParameterListUnit(_lexer, _logger)).parse;
          _state = 3;
          return true;
        }

        goto default;

      case Token.Type.Body:
      case Token.Type.Out:
      case Token.Type.In:
      case Token.Type.LeftCurly:
        if (_state == 0 || _state == 1 || _state == 2 || _state == 3) {
          _lexer.push(token);
          auto functionBody = (new FunctionBodyUnit(_lexer, _logger)).parse;
          return false;
        }

        goto default;

			default:
				_lexer.push(token);
        if (_state == 1) {
          auto type = (new TypeUnit(_lexer, _logger)).parse;
          _state = 2;
        }
        else {
          // Error
        }

				break;
		}

		return true;
	}
}
