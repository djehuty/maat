/*
 * expression_declaration_disambiguation_unit.d
 *
 */

module syntax.expression_declaration_disambiguation_unit;

import lex.lexer;
import lex.token;
import logger;

/*

  Identifier is found and is common with both.

  Identifier
  TypeDeclaration = (. Identifier)* Identifier ...

*/

class ExpressionDeclarationDisambiguationUnit {
public:
  enum Variant {
    Expression,
    Declaration
  }

private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

  Variant _variant;

  Token[] _tokens;

public:
	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	Variant parse() {
		Token token;

		do {
			token = _lexer.pop();
      _tokens ~= token;
		} while (tokenFound(token));

    foreach_reverse(t; _tokens) {
      _lexer.push(t);
    }

		return _variant;
	}

	bool tokenFound(Token token) {
		if (token.type == Token.Type.Comment) {
			return true;
		}

		switch (token.type) {
      case Token.Type.Dot:
        if (_state == 0 || _state == 1) {
          _state = 2;
        }
        else {
          return false;
        }
        break;

      case Token.Type.Identifier:
        if (_state == 2) {
          _state = 1;
        }
        else {
          _variant = Variant.Declaration;
          return false;
        }
        break;

      default:
        return false;
		}

		return true;
	}
}
