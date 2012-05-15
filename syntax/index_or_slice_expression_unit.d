/*
 * index_or_slice_expression_unit.d
 *
 */

module syntax.index_or_slice_expression_unit;

import syntax.assign_expression_unit;

import lex.lexer;
import lex.token;
import logger;

/*

  [
  IndexOrSliceExpression = IndexExpression
                         | SliceExpression

  IndexExpression = ArgumentList ]
  
  ArgumentList = AssignExpression
               | AssignExpression , ArgumentList

  SliceExpression = ]
                  | AssignExpression .. AssignExpression ]

*/

class IndexOrSliceExpressionUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

  bool _isSliceExpression;
  bool _isIndexExpression;

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
      case Token.Type.RightBracket:
        if (_state == 0){
          _isSliceExpression = true;
        }

        if (_state == 1 && !_isSliceExpression) {
          _isIndexExpression = true;
        }

        if (_isSliceExpression) {
          _logger.println("Woo Slice");
        }
        else if (_isIndexExpression){
          _logger.println("Woo Index");
        }

        if (_state == 2) {
          // Error: Expecting an expression.
          if (_isSliceExpression) {
            _logger.error(_lexer, token,
                "Expecting the upper bound for the slice.",
                "Did you mean to place a $ or some value here?",
                ["array[1..$] // Grab all but first value", "array[0..10] // Get first ten values"]);

            return false;
          }
          else if (_isIndexExpression) {
            _logger.error(_lexer, token,
                "Expecting an index after the comma.",
                "Did you mean to place a value here for this dimension?",
                ["array[0, 0] // Get the first value in this 2d array",
                 "array[$-1, $-1] // Get the last value in this 2d array"]);

            return false;
          }
        }

        // Done
        return false;

      case Token.Type.Slice:
        if (_state == 1) {
          if (_isIndexExpression) {
            // TODO: Error: Slice is found within index expression.
          }
          else if (_isSliceExpression) {
            // Error: Slice has multiple ranges.
          }

          _isSliceExpression = true;
          _state = 2;
        }
        break;

      case Token.Type.Comma:
        if (_state == 1) {
          if (_isSliceExpression) {
            // TODO: Error: Dimension index is found within slice
          }

          _isIndexExpression = true;
          _state = 2;
        }
        break;

			default:
        if (_state == 1) {
          // Error: Expression follows expression
          if (_isSliceExpression) {
            // Error: Slice contains two expressions
            _logger.error(_lexer, token,
                "Slice is not terminated correctly.",
                "Did you intend to place a symbol here? Perhaps a ']'?",
                ["array[1..$] // Grab all but first value", "array[i..i+x] // Get values at index i up to but not including i+x"]);
          }
          else if (_isIndexExpression) {
            // Error: Index contains two expressions
            _logger.error(_lexer, token,
                "Index is not formed correctly.",
                "Did you intend to place a symbol here? Perhaps a ','?",
                ["array[0, 0] // Get the first value in this 2d array",
                 "array[$-1, $-1] // Get the last value in this 2d array"]);
          }
          else {
            // Error: First expression is followed by second: [ Expr Expr
            _logger.error(_lexer, token,
                "Array indexing or slicing is not formed correctly.",
                "Did you intend to place a symbol here? Perhaps either a '..' or ','?",
                ["array[1..$] // Grab all but first value",
                 "array[i..i+x] // Get values at index i up to but not including i+x",
                 "array[0, 0] // Get the first value in this 2d array",
                 "array[$-1, $-1] // Get the last value in this 2d array"]);
          }
        }
				_lexer.push(token);
        auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;
        _state = 1;
				break;
		}

		return true;
	}
}
