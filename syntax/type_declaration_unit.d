/*
 * type_declaration_unit.d
 *
 */

module syntax.type_declaration_unit;

import syntax.declarator_unit;
import syntax.initializer_unit;
import syntax.function_body_unit;
import syntax.basic_type_unit;

import lex.lexer;
import lex.token;

import logger;

import ast.type_declaration_node;
import ast.declarator_node;
import ast.function_node;
import ast.variable_declaration_node;
import ast.type_node;

class TypeDeclarationUnit {
private:
	Lexer  _lexer;
	Logger _logger;
	int    _state = 0;

  TypeNode _basicType;
  TypeNode _type;
	DeclaratorNode _node;
	FunctionNode _function;
  VariableDeclarationNode _variable;
	char[] _comment;

public:
	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}

	TypeDeclarationNode parse() {
		// Get all comments
		_comment = "";
		while(!_lexer.commentEmpty()) {
			auto t = _lexer.commentPop();
			_comment = t.string ~ _comment;
		}

		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

    if (_function) {
      return new TypeDeclarationNode(_function);
    }

    if (_type is null) {
      _type = _basicType;
    }

    if (_variable is null) {
      _variable = new VariableDeclarationNode(_node.name, _type, null);
    }

    return new TypeDeclarationNode(_variable);
	}

	bool tokenFound(Token token) {
		if (token.type == Token.Type.Comment) {
			return true;
		}

		switch(this._state) {

			// Looking for a basic type or identifier
			case 0:
				switch (token.type) {
					case Token.Type.Bool:
					case Token.Type.Byte:
					case Token.Type.Ubyte:
					case Token.Type.Short:
					case Token.Type.Ushort:
					case Token.Type.Int:
					case Token.Type.Uint:
					case Token.Type.Long:
					case Token.Type.Ulong:
					case Token.Type.Char:
					case Token.Type.Wchar:
					case Token.Type.Dchar:
					case Token.Type.Float:
					case Token.Type.Double:
					case Token.Type.Real:
					case Token.Type.Ifloat:
					case Token.Type.Idouble:
					case Token.Type.Ireal:
					case Token.Type.Cfloat:
					case Token.Type.Cdouble:
					case Token.Type.Creal:
					case Token.Type.Void:
					case Token.Type.Identifier:
            _lexer.push(token);
            _basicType = (new BasicTypeUnit(_lexer, _logger)).parse();

						// We have a basic type... look for Declarator
						_node = (new DeclaratorUnit(_lexer, _logger)).parse(_basicType);
            this._state = 1;

            _type = _node.type;
						break;

					case Token.Type.Typeof:
						// TypeOfExpression
						// TODO: this
						break;

					// Invalid token for this _state
					case Token.Type.Assign:
						break;

					// Invalid token for this _state
					case Token.Type.Semicolon:
						break;

					default:

						// We will pass this off to a Declarator
						_lexer.push(token);
						auto decl = (new DeclaratorUnit(_lexer, _logger)).parse(_basicType);
						this._state = 1;
						break;
				}

			// We have found a basic type and are looking for either an initializer
			// or another type declaration. We could also have a function body
			// for function literals.
			case 1:
				switch(token.type) {
					case Token.Type.Semicolon:
						// Done
            if (_node !is null && _node.parameters !is null) {
  						_function = new FunctionNode(_node.name, _basicType, _node.parameters, null, null, null, _comment);
            }
						return false;
					case Token.Type.Comma:
						// Look for another declarator
						auto expr = (new DeclaratorUnit(_lexer, _logger)).parse(_basicType);
						break;

					case Token.Type.Assign:
						// Initializer
						auto expr = (new InitializerUnit(_lexer, _logger)).parse;
						this._state = 4;
						break;
					case Token.Type.LeftCurly:
					case Token.Type.In:
					case Token.Type.Out:
					case Token.Type.Body:
						// It could be a function body
						_lexer.push(token);
						auto function_body = (new FunctionBodyUnit(_lexer, _logger)).parse;
						_function = new FunctionNode(_node.name, _basicType, _node.parameters, null, null, null, _comment);
						return false;

					default:
						// Bad
						break;
				}
				break;

			case 4:
				switch(token.type) {
					case Token.Type.Comma:
						// Initializer list
						auto decl = (new DeclaratorUnit(_lexer, _logger)).parse(_basicType);
						_state = 1;
						break;

					case Token.Type.Assign:
						// Bad
            _logger.error(_lexer, token,
                "Declaration cannot contain more than one assignment."
                "Did you mean to place a semicolon here?",
                []);
						break;

					case Token.Type.Semicolon:
						// Done
						return false;

          default:
            // Bad
            _logger.error(_lexer, token,
                "Declaration malformed.",
                "Did you mean to place a semicolon here?",
                []);
            return false;
				}
				break;

			default:
				break;
		}
		return true;
	}
}
