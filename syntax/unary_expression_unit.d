/*
 * unary_expression_unit.d
 *
 */

module syntax.unary_expression_unit;

import syntax.postfix_expression_unit;
import syntax.cast_expression_unit;

import lex.lexer;
import lex.token;
import logger;

/*

	UnaryExpr => & UnaryExpr
	           | ++ UnaryExpr
			   | -- UnaryExpr
			   | * UnaryExpr
			   | - UnaryExpr
			   | + UnaryExpr
			   | ! UnaryExpr
			   | ~ UnaryExpr
			   | ( Type ) . Identifier
			   | NewExpr
			   | DeleteExpr
			   | CastExpr
			   | NewAnonClassExpr
			   | PostfixExpr

*/

class UnaryExpressionUnit {
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
      case Token.Type.Cast:
        auto cast_expr = (new CastExpressionUnit(_lexer, _logger)).parse;
        return false;

      // ComplementExpression: ~x
      case Token.Type.Cat:
        auto expr = (new UnaryExpressionUnit(_lexer, _logger)).parse;
        return false;

      // DereferenceExpression: *x
      case Token.Type.Mul:
        auto expr = (new UnaryExpressionUnit(_lexer, _logger)).parse;
        return false;

      // NegativeExpression: -x
      case Token.Type.Sub:
        auto expr = (new UnaryExpressionUnit(_lexer, _logger)).parse;
        return false;

      // NotExpression: !x
      case Token.Type.Bang:
        auto expr = (new UnaryExpressionUnit(_lexer, _logger)).parse;
        return false;

      // PositiveExpression: +x
      case Token.Type.Add:
        auto expr = (new UnaryExpressionUnit(_lexer, _logger)).parse;
        return false;

      // PreIncrementExpression: ++x
      case Token.Type.Increment:
        auto expr = (new UnaryExpressionUnit(_lexer, _logger)).parse;
        return false;

      // PreDecrementExpression: --x
      case Token.Type.Decrement:
        auto expr = (new UnaryExpressionUnit(_lexer, _logger)).parse;
        return false;

      // ReferenceExpression: &x
      case Token.Type.And:
        auto expr = (new UnaryExpressionUnit(_lexer, _logger)).parse;
        return false;

			default:
				_lexer.push(token);
				auto expr = (new PostfixExpressionUnit(_lexer, _logger)).parse;
				break;
		}

		return false;
	}
}
