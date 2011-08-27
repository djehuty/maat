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
			case DToken.Semicolon:
				return false;

			case DToken.Version:
				break;
			case DToken.Debug:
				break;
			case DToken.Static:
				break;
			case DToken.Class:
				break;
			case DToken.Interface:
				break;
			case DToken.Struct:
			case DToken.Union:
				break;
			case DToken.Mixin:
				break;
			case DToken.Template:
				break;
			case DToken.Enum:
				break;
			case DToken.This:
				break;
			case DToken.Cat:
				break;
			case DToken.Do:
				break;
			case DToken.While:
				break;
			case DToken.If:
				break;
			case DToken.With:
				break;
			case DToken.For:
				auto tree = expand!(ForStmtUnit)();
				break;
			case DToken.Foreach:
				auto tree = expand!(ForeachStmtUnit)();
				break;
			case DToken.Foreach_reverse:
				break;
			case DToken.Synchronized:
				break;
			case DToken.Volatile:
				Console.putln("Volatile: ");
				auto tree = expand!(VolatileStmtUnit)();
				break;
			case DToken.Case:
				auto tree = expand!(CaseStmtUnit)();
				break;
			case DToken.Switch:
				auto tree = expand!(SwitchStmtUnit)();
				break;
			case DToken.Default:
				auto tree = expand!(DefaultStmtUnit)();
				break;
			case DToken.Continue:
				auto tree = expand!(ContinueStmtUnit)();
				break;
			case DToken.Break:
				auto tree = expand!(BreakStmtUnit)();
				break;
			case DToken.Goto:
				auto tree = expand!(GotoStmtUnit)();
				break;
			case DToken.Return:
				Console.putln("Return: ");
				auto tree = expand!(ReturnStmtUnit)();
				break;
			case DToken.Throw:
				Console.putln("Throw: ");
				auto tree = expand!(ThrowStmtUnit)();
				break;
			case DToken.Scope:
				break;
			case DToken.Try:
				break;
			case DToken.Pragma:
				auto tree = expand!(PragmaStmtUnit)();
				break;

			// EWWW cases
			case DToken.Identifier:
				break;
			default:
				break;
		}
		return true;
	}

protected:
	string cur_string = "";

	static const string _common_error_msg = "";
	static const string[] _common_error_usages = null;
}
