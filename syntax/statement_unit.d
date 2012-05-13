/*
 * statement_unit.d
 *
 */

module syntax.statement_unit;

import syntax.if_statement_unit;
import syntax.for_statement_unit;
import syntax.foreach_statement_unit;
import syntax.case_statement_unit;
import syntax.goto_statement_unit;
import syntax.throw_statement_unit;
import syntax.switch_statement_unit;
import syntax.continue_statement_unit;
import syntax.default_statement_unit;
import syntax.break_statement_unit;
import syntax.pragma_statement_unit;
import syntax.return_statement_unit;
import syntax.volatile_statement_unit;

import syntax.expression_unit;

import syntax.type_declaration_unit;

import lex.lexer;
import lex.token;
import logger;

class StatementUnit {
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
		if (_state == 1 && token.type == Token.Type.Semicolon) {
			// Good.
			return false;
		}
		else if (_state == 1) {
			// Bad. Expected ;
		}

		switch (token.type) {
			case Token.Type.Version:
				break;
			case Token.Type.Debug:
				break;
			case Token.Type.Static:
				break;
			case Token.Type.Class:
				break;
			case Token.Type.Interface:
				break;
			case Token.Type.Struct:
			case Token.Type.Union:
				break;
			case Token.Type.Mixin:
				break;
			case Token.Type.Template:
				break;
			case Token.Type.Enum:
				break;
			case Token.Type.This:
				break;
			case Token.Type.Cat:
				break;
			case Token.Type.Do:
				break;
			case Token.Type.While:
				break;
			case Token.Type.If:
				auto stmt = (new IfStatementUnit(_lexer, _logger)).parse;
				return false;
			case Token.Type.With:
				break;
			case Token.Type.For:
				auto stmt = (new ForStatementUnit(_lexer, _logger)).parse;
				return false;
			case Token.Type.Foreach:
				auto stmt = (new ForeachStatementUnit(_lexer, _logger)).parse;
				return false;
			case Token.Type.Foreach_reverse:
				break;
			case Token.Type.Synchronized:
				break;
			case Token.Type.Volatile:
				auto stmt = (new VolatileStatementUnit(_lexer, _logger)).parse;
				break;
			case Token.Type.Case:
				auto stmt = (new CaseStatementUnit(_lexer, _logger)).parse;
				break;
			case Token.Type.Switch:
				auto stmt = (new SwitchStatementUnit(_lexer, _logger)).parse;
				break;
			case Token.Type.Default:
				auto stmt = (new DefaultStatementUnit(_lexer, _logger)).parse;
				break;
			case Token.Type.Continue:
				auto stmt = (new ContinueStatementUnit(_lexer, _logger)).parse;
				break;
			case Token.Type.Break:
				auto stmt = (new BreakStatementUnit(_lexer, _logger)).parse;
				break;
			case Token.Type.Goto:
				auto stmt = (new GotoStatementUnit(_lexer, _logger)).parse;
				break;
			case Token.Type.Return:
				auto stmt = (new ReturnStatementUnit(_lexer, _logger)).parse;
        return false;
			case Token.Type.Throw:
				auto stmt = (new ThrowStatementUnit(_lexer, _logger)).parse;
				break;
			case Token.Type.Scope:
				break;
			case Token.Type.Try:
				break;
			case Token.Type.Pragma:
				auto stmt = (new PragmaStatementUnit(_lexer, _logger)).parse;
				break;

			// int a = 5;
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
				// Declaration
				_lexer.push(token);
				auto decl = (new TypeDeclarationUnit(_lexer, _logger)).parse;
				return false;

			case Token.Type.Identifier:
				// I DON'T KNOW. COULD BE AN EXPRESSION:
				//  a = 5;
				// OR A TYPE DECLARATION!
				// size_t foo = 4;
				
				// Must disabiguate
				break;
			
			// 2 + 2;
			default:
				_lexer.push(token);
				auto expr = (new ExpressionUnit(_lexer, _logger)).parse;
				_state = 1;
				break;
		}
		return true;
	}
}
