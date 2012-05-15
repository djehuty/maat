/*
 * array_literal_disambiguation_unit.d
 *
 */

module syntax.array_literal_disambiguation_unit;

import lex.lexer;
import lex.token;

import logger;

class ArrayLiteralDisambiguationUnit {
public:
  enum ArrayLiteralVariant {
    Array,
    AssociatedArray
  }

private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	ArrayLiteralVariant parse() {
		Token token = _lexer.pop();
    _lexer.push(token);

    return ArrayLiteralVariant.Array;
	}
}

