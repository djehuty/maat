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

class StatementUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.Semicolon:
				return false;

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
				break;
			case Token.Type.With:
				break;
			case Token.Type.For:
				auto tree = expand!(ForStmtUnit)();
				break;
			case Token.Type.Foreach:
				auto tree = expand!(ForeachStmtUnit)();
				break;
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

			// EWWW cases
			case Token.Type.Identifier:
				break;
			default:
				break;
		}
		return true;
	}

protected:
	char[] cur_string = "";

	static const char[] _common_error_msg = "";
	static const char[][] _common_error_usages = null;
}
