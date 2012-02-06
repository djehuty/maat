/*
 * basictypesuffixunit.d
 *
 */

module syntax.basictypesuffixunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;

import syntax.expressionunit;
import syntax.parameterlistunit;

import tango.io.Stdout;
/*

*/

class BasicTypeSuffixUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch(state) {
			case 0:
				switch (current.type) {
					case Token.Type.Mul:
						return false;

					case Token.Type.LeftBracket:
						state = 1;
						break;

					case Token.Type.Delegate:
					case Token.Type.Function:
						state = 2;
						break;

					default:
						// Error:
						// TODO:
						Stdout("terrible").newline;
						break;
				}
				break;

			// Saw [ looking for Expression, Type, or ]
			case 1:
				switch(current.type) {
					case Token.Type.RightBracket:
						return false;

					default:
						// XXX: Disambiguate between Type and Expression
						lexer.push(current);
						auto tree = expand!(ExpressionUnit);
						state = 3;
						break;
				}
				break;

			// Saw Delegate/Function ... looking for ( ParameterList
			case 2:
				switch(current.type) {
					case Token.Type.LeftParen:
						auto tree = expand!(ParameterListUnit)();
						return false;

					default:
						// Bad
						break;
				}
				break;

			// Saw Expression, looking for .. or ]
			case 3:
				switch(current.type) {
					case Token.Type.RightBracket:
						return false;

					case Token.Type.Slice:
						auto tree = expand!(ExpressionUnit);
						state = 4;
						break;
				}
				break;

			// Saw Expression .. Expression, looking for ]
			case 4:
				switch(current.type) {
					case Token.Type.RightBracket:
						return false;
					default:
						// Bad
						break;
				}
		}
		return true;
	}
}
