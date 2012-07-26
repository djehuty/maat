/*
 * struct_initializer_unit.d
 *
 */

module syntax.struct_initializer_unit;

import syntax.array_initializer_unit;

import syntax.assign_expression_unit;

import lex.lexer;
import lex.token;
import logger;

/*

  {
  StructInitializer        => StructMemberInitializers }

  StructMemberInitializers => StructMemberInitializer
                            | StructMemberInitializer ,
                            | StructMemberInitializer , StructMemberInitializers

  StructMemberInitializer  => NonVoidInitializer
                            | Identifier : NonVoidInitializer

*/

class StructInitializerUnit {
private:
  Lexer  _lexer;
  Logger _logger;

  int    _state;

  static const char[][] _common_error_usages = [
    "Struct foo = {}"];

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
      case Token.Type.RightCurly:
        if (_state == 2) {
          // Oddly, this is allowed.
        }

        // Done
        return false;

      case Token.Type.Comma:
        if (_state == 0) {
          // Error: Have not seen any expressions.
          _logger.error(_lexer, token,
              "Array literal is malformed due to an unexpected comma.",
              "This array literal should start with a value.",
              _common_error_usages);
        }
        else if (_state == 2) {
          // Error: Double comma.
          _logger.error(_lexer, token,
              "Array literal is malformed due to an unexpected comma.",
              "Did you mean to have one comma? Or maybe you forgot a value?",
              _common_error_usages);
        }
        else if (_state == 1 || _state == 4) {
          // Have seen an expression
          _state = 2;
        }
        break;

      case Token.Type.Colon:
        if (_state == 0 || _state == 2) {
          // Error. Have not seen any expressions.
          _logger.error(_lexer, token,
              "Array literal is malformed due to an unexpected colon.",
              "This array literal should start with a value.",
              _common_error_usages);
          return false;
        }
        else if (_state == 3) {
          // Error: Double colon.
          _logger.error(_lexer, token,
              "Array literal is malformed due to an unexpected colon.",
              "Did you accidentally place two colons here?",
              _common_error_usages);
          return false;
        }
        else if (_state == 4) {
          // Error: Double colon (colon after expression)
          _logger.error(_lexer, token,
              "Array literal has too many indexes.",
              "Only one index can be used. Did you mean to place a comma?",
              _common_error_usages);
          return false;
        }
        else if (_state == 1) {
          // Have seen an expression
          _state = 3;
        }
        else {
          goto default;
        }
        break;

      case Token.Type.LeftBracket:
        if (_state == 0 || _state == 2 || _state == 3) {
          auto expr = (new ArrayInitializerUnit(_lexer, _logger)).parse;
          _state = 1;
        }
        else {
          // Follow through for error
          goto default;
        }
        break;

      case Token.Type.LeftCurly:
        if (_state == 0 || _state == 2 || _state == 3) {
          auto expr = (new StructInitializerUnit(_lexer, _logger)).parse;
          _state = 1;
        }
        else {
          // Follow through for error
          goto default;
        }
        break;

      default:
        // AssignExpression
        if (_state == 3) {
          _lexer.push(token);
          auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
          _state = 4;
        }
        else if (_state == 0 || _state == 2) {
          _lexer.push(token);
          auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
          _state = 1;
        }
        else {
          // Error: Did not see a comma.
          _logger.error(_lexer, token,
              "Array literal is malformed due to multiple expressions given.",
              "Did you mean to place a comma here?",
              _common_error_usages);
          return false;
        }
        break;
    }

    return true;
  }
}
