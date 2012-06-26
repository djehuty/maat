/*
 * version_statement_unit.d
 *
 */

module syntax.version_statement_unit;

import syntax.declaration_unit;
import syntax.block_statement_unit;

import lex.lexer;
import lex.token;
import logger;

/*

  version
  VersionStatement = ( Identifier ) DeclarationBlock
                   | ( IntegerLiteral ) DeclarationBlock

  DeclarationBlock = { }
                   | Declaration
                   | { Declarations }

  Declarations = Declaration
               | Declaration Declarations

*/               

class VersionStatementUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;
  bool   _asDeclaration;

	char[] _cur_string;

public:

	this(bool asDeclaration, Lexer lexer, Logger logger) {
    _asDeclaration = asDeclaration;
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
    if (_state == 7 && token.type != Token.Type.Else) {
      // Done
      _lexer.push(token);
      return false;
    }

		if (this._state == 4) {
			// We are looking for declarations
			if (token.type == Token.Type.RightCurly) {
				// Done. Maybe.
        _state = 7;
			}
			else {
        _lexer.push(token);
        if (_asDeclaration) {
          auto decl = (new DeclarationUnit(_lexer, _logger)).parse;
        }
        else {
          auto decl = (new BlockStatementUnit(_lexer, _logger)).parse;
          _state = 7;
        }
			}
			return true;
		}

		// Else, we are looking for the condition

		switch (token.type) {
			// We could be declaring a version
			// version = Release; etc
			case Token.Type.Assign:
				if (this._state == 1) {
					// Error: Already started to use an identifier
					// TODO:
				}
				else if (this._state == 2) {
					// Error: Already named an identifier.
					// TODO:
				}
				else if (this._state == 3) {
					// Error: Found right paren.
					// TODO:
				}

				// We need to find the identifier or integer to enable.
				this._state = 5;
				break;

			// Look for a left paren first. It must exist.
			case Token.Type.LeftParen:
				if (this._state == 1) {
					// Error: Too many left parentheses.
					// TODO:
				}
				else if (this._state == 2) {
					// Error: Found an identifier.
					// TODO: Probably mistook left for right parenthesis.
				}
				else if (this._state == 3) {
					// Error: We already found a right paren... Expected colon or brace
					// TODO:
				}
        else {
          this._state = 1;
        }
				break;

			// For version assignment, we are looking for a semicolon to end it.
			case Token.Type.Semicolon:
				if (this._state == 5) {
					// Error: No identifier given.
					// TODO:
				}
				else if (this._state == 0) {
					// Error: Need '=' first.
					// TODO:
				}
				else if (this._state == 1) {
					// Error: Have left paren.
					// TODO:
				}
				else if (this._state == 2) {
					// Error: Have Identifier for normal foo.
					// TODO:
				}
				else if (this._state == 3) {
					// Error: Have right paren.
					// TODO:
				}

				// else this._state == 6

				// Done.
				return false;

      case Token.Type.Else:
        if (_state == 7) {
          // Good.
          _state = 8;
        }
        break;

			// Looking for some literal or identifier to use as the version
			case Token.Type.Identifier:
			case Token.Type.IntegerLiteral:
				if (this._state == 5) {
					// We are assigning a version
					_cur_string = token.string;
					this._state = 6;
				}
				else if (this._state == 6) {
					// Error: Too many identifiers in a row on a version assign.
					// TODO:
				}
				else if (this._state == 0) {
					// Error: No left parenthesis.
					// TODO: Probably forgot it!
				}
				else if (this._state == 2) {
					// Error: Too many identifiers in a row!
					// TODO: Probably put a space or something in.
				}
				else if (this._state == 3) {
					// Error: Found right parenthesis.
					// TODO: Probably forgot a curly brace.
				}
				else {
					_cur_string = token.string;
					this._state = 2;
				}
				break;

			case Token.Type.RightParen:
				if (this._state == 0) {
					// Error: Do not have a left paren.
					// TODO: Probably forgot a left parenthesis.
				}
				else if (this._state == 3) {
					// Error: Too many right parens
					// TODO:
				}

				// Now we can look for a : or a curly brace for a declaration block
				this._state = 3;
				break;

			// For declaring the rest of the file under this conditional block
			// static if (foo):
			case Token.Type.Colon:
				if (this._state == 0) {
					// Error: Do not have a condition!
					// TODO:
				}
				else if (this._state == 1) {
					// Error: Do not have an identifier.
					// TODO:
				}
				else if (this._state == 2) {
					// Error: Do not have a right paren.
					// TODO:
				}
				else if (this._state == 4) {
					// Error: After a left curly brace. We are within the block.
					// TODO:
				}

				// Done.
				return false;

			// For specifying a declaration block for this condition
			case Token.Type.LeftCurly:
				if (this._state == 0) {
					// Error: Do not have a condition!
					// TODO:
				}
				else if (this._state == 1) {
					// Error: Do not have an identifier.
					// TODO:
				}
				else if (this._state == 2) {
					// Error: Do not have a right paren.
					// TODO:
				}

				// Now we look for declarations.
        this._state = 4;
				break;

			default:
        if (_state == 3 || _state == 8) {
          // Declaration
          _lexer.push(token);
          auto decl = (new DeclarationUnit(_lexer, _logger)).parse;
          if (_state == 8) {
            // Done.
            return false;
          }
          _state = 7;
        }
				break;
		}
		return true;
	}
}
