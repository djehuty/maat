/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.statementunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.foreachstmtunit;
import syntax.forstmtunit;
import syntax.switchstmtunit;
import syntax.casestmtunit;
import syntax.defaultstmtunit;
import syntax.breakstmtunit;
import syntax.gotostmtunit;
import syntax.continuestmtunit;
import syntax.returnstmtunit;
import syntax.volatilestmtunit;
import syntax.throwstmtunit;
import syntax.pragmastmtunit;
import syntax.ifstmtunit;

import syntax.typedeclarationunit;
import syntax.expressionunit;

import tango.io.Stdout;

class StatementUnit : ParseUnit {
	override bool tokenFound(Token current) {
		if (state == 1 && current.type == Token.Type.Semicolon) {
			// Good.
			return false;
		}
		else if (state == 1) {
			// Bad. Expected ;
		}

		switch (current.type) {
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
				auto tree = expand!(IfStmtUnit)();
				return false;
			case Token.Type.With:
				break;
			case Token.Type.For:
				auto tree = expand!(ForStmtUnit)();
				return false;
			case Token.Type.Foreach:
				auto tree = expand!(ForeachStmtUnit)();
				return false;
			case Token.Type.Foreach_reverse:
				break;
			case Token.Type.Synchronized:
				break;
			case Token.Type.Volatile:
				auto tree = expand!(VolatileStmtUnit)();
				break;
			case Token.Type.Case:
				auto tree = expand!(CaseStmtUnit)();
				break;
			case Token.Type.Switch:
				auto tree = expand!(SwitchStmtUnit)();
				break;
			case Token.Type.Default:
				auto tree = expand!(DefaultStmtUnit)();
				break;
			case Token.Type.Continue:
				auto tree = expand!(ContinueStmtUnit)();
				break;
			case Token.Type.Break:
				auto tree = expand!(BreakStmtUnit)();
				break;
			case Token.Type.Goto:
				auto tree = expand!(GotoStmtUnit)();
				break;
			case Token.Type.Return:
				auto tree = expand!(ReturnStmtUnit)();
				break;
			case Token.Type.Throw:
				auto tree = expand!(ThrowStmtUnit)();
				break;
			case Token.Type.Scope:
				break;
			case Token.Type.Try:
				break;
			case Token.Type.Pragma:
				auto tree = expand!(PragmaStmtUnit)();
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
				lexer.push(current);
				auto tree = expand!(TypeDeclarationUnit)();
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
				lexer.push(current);
				auto tree = expand!(ExpressionUnit)();
				state = 1;
				break;
		}
		return true;
	}

	protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
