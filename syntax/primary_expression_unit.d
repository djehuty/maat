/*
 * primary_expression_unit.d
 *
 */

module syntax.primary_expression_unit;

import syntax.array_literal_disambiguation_unit;
import syntax.array_literal_unit;

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

		switch (token.type) {
			case Token.Type.StringLiteral:
				_cur_string = token.string;
				return false;
			case Token.Type.IntegerLiteral:
				return false;
			case Token.Type.Identifier:
				return false;
      case Token.Type.LeftBracket:
        // Disambiguate between different array literal types:
        auto arrayType = (new ArrayLiteralDisambiguationUnit(_lexer, _logger)).parse;
        if (arrayType == ArrayLiteralDisambiguationUnit.ArrayLiteralVariant.Array) {
          auto array = (new ArrayLiteralUnit(_lexer, _logger)).parse;
        }
        return false;
			default:
				break;
		}
		return false;
	}
}
