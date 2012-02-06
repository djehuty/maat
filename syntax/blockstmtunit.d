/*
 * blockunit.d
 *
 */

module syntax.blockstmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.statementunit;

import tango.io.Stdout;

class BlockStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case Token.Type.RightCurly:
				// Done.
				return false;
			default:
				// We can look for a simple declaration
				lexer.push(current);
				auto tree = expand!(StatementUnit)();

				Stdout("Statement Consumed").newline;
				break;
		}
		return true;
	}
}
