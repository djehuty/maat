/*
 * initializerunit.d
 *
 */

module syntax.initializerunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.assignexprunit;

import tango.io.Stdout;
/*

*/

class InitializerUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (state) {
			case 0:
				switch (current.type) {
					case Token.Type.Void:
						return false;

					case Token.Type.LeftBracket:
						// Could be an ArrayInitializer
						return false;

					case Token.Type.LeftCurly:
						// Could be a StructInitializer
						return false;

					default:
						// AssignExpression
						lexer.push(current);
						auto tree = expand!(AssignExprUnit)();
						return false;
				}
				break;
		}
		return true;
	}
}
