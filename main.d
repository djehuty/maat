import lex.lexer;
import lex.token;

import logger;

import syntax.parser;

import tango.io.Stdout;

import ast.class_node;
import ast.declaration_node;

int main() {
	auto lex = new Lexer("test/stream.di");

	Parser p = new Parser(lex);
	Logger logger = new Logger();
	auto ast = p.parse(logger);

	foreach(decl; ast.imports) {
		Stdout("Importing ")(decl.moduleName).newline;
	}

	foreach(decl; ast.declarations) {
		if (decl.type == DeclarationNode.Type.ClassDeclaration) {
			auto classNode = cast(ClassNode)decl.node;
			Stdout("Class: ")(classNode.name).newline;
			foreach(func; classNode.constructors) {
				Stdout("  Constructor!").newline;
			}
			if (classNode.destructor !is null) {
				Stdout("  Destructor!").newline;
			}
			foreach(func; classNode.methods) {
				Stdout("  Function: ")(func.name).newline;
			}
		}
	}

	return 0;
}
