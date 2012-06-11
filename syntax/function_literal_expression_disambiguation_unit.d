/*
 * function_literal_expression_disambiguation_unit.d
 *
 */

module syntax.function_literal_expression_disambiguation_unit;

import lex.lexer;
import lex.token;
import logger;

/*

  It is a function literal when the following matches:

  (
  FunctionLiteralExpressionDisambiguation = (NotParen)* ) {
                                          | (NotParen)* ( AnyParenthesized ) {

  (
  AnyParenthesized = (NotParen)* )
                   | (NotParen)* ( AnyParenthesized AnyParenthesized

*/

class FunctionLiteralExpressionDisambiguationUnit {
public:
  enum ExpressionVariant {
    FunctionLiteral,
    Expression,
  }

private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

  Token[] _tokens;

  ExpressionVariant _variant;

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	ExpressionVariant parse() {
    // Starts with a left paren already consumed.
    _state = 1;

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

    if (token.type == Token.Type.LeftParen) {
      if (_state == 0) {
        // Hmm. An error is likely, but not a function literal for that matter.
        _variant = ExpressionVariant.Expression;
        return false;
      }
      _state++;
    }
    else if (token.type == Token.Type.RightParen) {
      _state--;

      if (_state < 0) {
        // It is an expression since the right paren appears awkwardly
        // meaning that this is a parenthesized expression within another.
        _variant = ExpressionVariant.Expression;
        return false;
      }
    }
    else if (token.type == Token.Type.LeftCurly) {
      if (_state == 0) {
        // Function Literal
        _variant = ExpressionVariant.FunctionLiteral;
        return false;
      }
    }
    else if (_state == 0) {
      // { should appear directly outside of the parameter list. It does not.
      _variant = ExpressionVariant.Expression;
      return false;
    }

    return true;
  }
}
