/*
 * parameter_unit.d
 *
 */

module syntax.parameter_unit;

import syntax.assign_expression_unit;
import syntax.declarator_middle_unit;
import syntax.basic_type_unit;

import ast.variable_declaration_node;
import ast.declarator_node;
import ast.type_node;

import lex.lexer;
import lex.token;
import logger;

/*

	Parameter => ( ref | out | in | lazy )? BasicType Declarator ( = AssignExpr )?
			   | ( ref | out | in | lazy )? BasicType ( ... )?
			   | ( ref | out | in | lazy )? BasicType DeclaratorMiddle ( ... )?

	(can start with one of these: {* [ ( delegate function})
	Declarator => ( BasicTypeSuffix )? ( Declarator ) ( DeclaratorSuffix )*
	            | ( BasicTypeSuffix )? Identifier ( DeclaratorSuffix )*

	Declarators HAVE identifiers... DeclaratorMiddles... Don't
	Parameters can have one, the other, or none (eff)

	(must start with one of these: {* [ ( delegate function})
	DeclaratorMiddle => ( BasicTypeSuffix )? ( ( DeclaratorMiddle ) )? ( DeclaratorSuffix )*
	Examples: ref void[], in int, out int (no declarator... technically possible in a parameter)

	DeclaratorSuffix => [ ]
	                  | [ Expression ]
	                  | [ Type ]
	                  | ( ( TemplateParameterList )? ( ParameterList

	BasicTypeSuffix => *
	                 | [ ]
	                 | [ Expression ]
					 | [ Expression .. Expression ]
	                 | [ Type ]
	                 | delegate ( ParameterList
	                 | function ( ParameterList

	Must disambiguate between BasicTypeSuffix and DeclaratorSuffix
	If it is a BasicTypeSuffix, disambiguate between Declarator and
	DeclaratorMiddle by looking for a following Identifier or (
	If it is a ( then it could still be either a Declarator or DeclaratorMiddle
	until it finds an Identifier.

	The only difference is that a Declarator can have an initial value.
	That is, = is only allowed (and ... disallowed) when a Declarator is
	found over a DeclaratorMiddle.

*/

class ParameterUnit {
private:
	Lexer  _lexer;
	Logger _logger;

	int    _state;

	enum States {
		Start,
		FoundPassBySpecifier,
		FoundBasicType,
		FoundDeclaratorMiddle,
	}

	// For TypeNode formation
	TypeNode.Type _type;
	TypeNode      _subtype;
	char[]        _identifier;

	char[]        _name;

	DeclaratorNode _node;

public:

	this(Lexer lexer, Logger logger) {
		_lexer  = lexer;
		_logger = logger;
	}
	
	VariableDeclarationNode parse() {
		Token token;

		do {
			token = _lexer.pop();
		} while (tokenFound(token));

		return new VariableDeclarationNode(_name,
		                                   new TypeNode(_type, _subtype, _identifier),
										   null);
	}

	bool tokenFound(Token token) {
		switch (token.type) {
			// Default Initializers
			case Token.Type.Assign:
				if (_state != States.FoundDeclaratorMiddle) {
					// Error: We don't have a declarator!
					// TODO:
				}

				// TODO:
				auto expr = (new AssignExpressionUnit(_lexer, _logger)).parse;

				// Done.
				return false;

			// Figure out the specifier.
			case Token.Type.In:
			case Token.Type.Out:
			case Token.Type.Ref:
			case Token.Type.Lazy:
				if (_state != States.Start) {
					// Error: Already have an in, out, ref, or lazy specifier.
					// TODO:
				}

				// Specifier.

				_state = States.FoundPassBySpecifier;

				// Fall through to hit the declarator call

				goto default;

			case Token.Type.Variadic:
				if (_state != States.FoundDeclaratorMiddle) {
					// Error:
					// TODO:
				}

				// Done
				return false;

			case Token.Type.LeftParen:
			case Token.Type.Delegate:
			case Token.Type.Function:
			case Token.Type.Mul:
			case Token.Type.LeftBracket:
				if (_state != States.FoundBasicType) {
					// Error:
					// TODO:
				}

				_lexer.push(token);

				_node = (new DeclaratorMiddleUnit(_lexer, _logger)).parse;
				_name = _node.name;
				_state = States.FoundDeclaratorMiddle;
				break;

			default:
				_lexer.push(token);

				if (_state == States.FoundBasicType) {
					// Could be a declarator then.
					_node = (new DeclaratorMiddleUnit(_lexer, _logger)).parse;
					_name = _node.name;
					_state = States.FoundDeclaratorMiddle;
				}
				else if (_state == States.Start ||
						_state == States.FoundPassBySpecifier) {
					// Hopefully this is a BasicType 
					auto typeNode = (new BasicTypeUnit(_lexer, _logger)).parse;
					_type = typeNode.type;
					_subtype = typeNode.subtype;
					_identifier = typeNode.identifier;

					_state = States.FoundBasicType;
				}
				else if (_state == States.FoundDeclaratorMiddle) {
					// Done
					return false;
				}
				break;
		}
		return true;
	}
}
