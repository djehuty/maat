/*
 * type_unit.d
 *
 */

module syntax.type_unit;

import syntax.basic_type_unit;
import syntax.basic_type_suffix_unit;

import lex.lexer;
import lex.token;
import logger;

class TypeUnit {
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
    if (_state == 0) {
      _lexer.push(token);
      auto basicType = (new BasicTypeUnit(_lexer, _logger)).parse;
      _state = 1;
    }
    else {
      _lexer.push(token);
      switch(token.type) {
        default:
          return false;
          break;

        case Token.Type.Mul:
        case Token.Type.Function:
        case Token.Type.Delegate:
        case Token.Type.LeftBracket:
          auto basicTypeSuffix = (new BasicTypeSuffixUnit(_lexer, _logger)).parse;
          break;
      }
    }

		return true;
	}
}
