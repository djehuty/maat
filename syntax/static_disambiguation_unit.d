/*
 * static_disambiguation_unit.d
 *
 */

module syntax.static_disambiguation_unit;

import syntax.static_if_statement_unit;
import syntax.static_assert_statement_unit;
import syntax.type_declaration_unit;

import ast.declaration_node;
import ast.type_declaration_node;

import lex.lexer;
import lex.token;
import logger;

class StaticDisambiguationUnit {
public:
  enum StaticVariant {
    StaticIf,
    StaticAssert,
    StaticConstructor,
    StaticDestructor,
    StaticAttribute
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
	
	StaticVariant parse() {
		Token token = _lexer.pop();
    _lexer.push(token);

    if (token.type == Token.Type.If) {
      return StaticVariant.StaticIf;
    }

    if (token.type == Token.Type.Assert) {
      return StaticVariant.StaticAssert;
    }

    if (token.type == Token.Type.This) {
      return StaticVariant.StaticConstructor;
    }

    if (token.type == Token.Type.Cat) {
      return StaticVariant.StaticDestructor;
    }

    return StaticVariant.StaticAttribute;
	}
}
