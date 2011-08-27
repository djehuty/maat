/*
 * expressionunit.d
 *
 * This module parses expressions.
 *
 */

module syntax.pragmastmtunit;

import syntax.parseunit;
import lex.token;

import syntax.nodes;
import syntax.statementunit;

class PragmaStmtUnit : ParseUnit {
	override bool tokenFound(Token current) {
		switch (current.type) {
			case DToken.LeftParen:
				if(this.state >= 1){
					//XXX: Error
				}

				this.state = 1;
				break;
			case DToken.Identifier:
				if(this.state != 1){
					//XXX: Error
				}

				cur_string = current.value.toString();
				Console.putln("Pragma: ", current.value);
				this.state = 2;
				break;
			case DToken.RightParen:
				if(this.state != 2 && this.state != 3){
					//XXX: Error
				}

				if (this.state == 2) {
					auto tree = expand!(StatementUnit)();
				}

				// Done.
				return false;
			case DToken.Comma:
				if(this.state != 2){
					//XXX: Error
				}

				this.state = 3;

				//TODO: Argument List
				
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
