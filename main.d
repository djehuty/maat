module main;

import lex.lexer;
import lex.token;

import logger;

import syntax.parser;

import tango.io.Stdout;

import Integer = tango.text.convert.Integer;

import ast.class_node;
import ast.declaration_node;

import tango.io.device.File;

import tango.io.FilePath;
import Path = tango.io.Path;
import tango.text.Unicode;
import tango.text.Util;

struct CommentData {
  char[] sectionSwitch;
  char[] description;
  char[] returns;
  char[][] params;
}

CommentData formatComment(char[] comment) {
  CommentData ret;

  bool inParamDescription = false;
  bool inReturnDescription = false;

  ret.description = "";
  foreach(line; lines(comment)) {
    line = trim(line);
    if (line.length > 0) {
      if (line[0] == '*') {
        line = trim(line[1..$]);
      }
      else if (line[$-2..$] == "//") {
        ret.sectionSwitch = trim(line[0..$-2]);
        continue;
      }

      if (contains(line, ':')) {
        auto idx = locate(line, ':');
        auto name = trim(line[0..idx]);
        auto desc = trim(line[idx+1..$]);

        if (name == "Returns") {
          inReturnDescription = true;
          inParamDescription = false;
          ret.returns = desc;
        }
        else {
          inParamDescription = true;
          inReturnDescription = false;
          ret.params ~= name;
          ret.params ~= desc;
        }
        continue;
      }
    }

    if (inParamDescription) {
      ret.params[$-1] ~= " " ~ trim(line);
    }
    else if (inReturnDescription) {
      ret.returns ~= " " ~ trim(line);
    }
    else {
      ret.description ~= trim(line) ~ " ";
    }
  }

  ret.description = trim(ret.description);

  return ret;
}

char[] camelCase(char[] name) {
  char[] result = "";
  bool lastWasUnderscore = false;

  foreach(chr; name) {
    if (result == "") {
      result ~= toUpper([chr]);
    }
    else if (lastWasUnderscore) {
      lastWasUnderscore = false;
      result ~= toUpper([chr]);
    }
    else if (chr == '_') {
      lastWasUnderscore = true;
    }
    else {
      result ~= chr;
    }
  }

  return result;
}

void write(File file, char[] str) {
  file.write(str);
}

void writeln(File file, char[] line) {
  write(file, line);
  write(file, "\n");
}

void parseFile(char[] filename, char[] outputPath) {
	auto lex = new Lexer(filename);

	Parser p = new Parser(lex);
	Logger logger = new Logger();

  auto file = new File(outputPath, File.WriteCreate);

  try {
    auto ast = p.parse(logger);

    writeln(file, "module: " ~ ast.name);

    writeln(file, "dependencies:");
    foreach(decl; ast.imports) {
      writeln(file, "  - " ~ decl.moduleName);
    }

    foreach(decl; ast.declarations) {
      if (decl.type == DeclarationNode.Type.ClassDeclaration) {
        auto classNode = cast(ClassNode)decl.node;
        auto classCommentData = formatComment(classNode.comment);
        writeln(file, "class: " ~ classNode.name);
        writeln(file, "description: \"" ~ classCommentData.description ~ "\"");
        writeln(file, "functions:");

        foreach(func; classNode.constructors) {
          auto constructorCommentData = formatComment(func.comment);
          writeln(file, "  - constructor: \"" ~ constructorCommentData.description ~ "\"");
          writeln(file, "    parameters:");
          foreach(param; func.parameters) {
            writeln(file, "    - type: \"" ~ param.type.identifier ~ "\"");
            writeln(file, "      name: \"" ~ param.name ~ "\"");
          }
        }

        if (classNode.destructor !is null) {
        }

        bool inProperties = true;

        foreach(func; classNode.methods) {
          auto commentData = formatComment(func.comment);
          if (commentData.sectionSwitch == "Methods") {
            inProperties = false;
          }

          if (inProperties) {
            write(file, "  - property: ");
          }
          else {
            write(file, "  - method: ");
          }

          writeln(file, "\"" ~ func.name ~ "\"");
          writeln(file, "    description: \"" ~ commentData.description ~ "\"");

          writeln(file, "    parameters:");
          foreach(param; func.parameters) {
            writeln(file, "    - type: \"" ~ param.type.identifier ~ "\"");
            writeln(file, "      name: \"" ~ param.name ~ "\"");
            for(int i = 0; i < commentData.params.length; i += 2) {
              if (commentData.params[i] == param.name) {
                writeln(file, "      description: \"" ~ commentData.params[i+1] ~ "\"");
                break;
              }
            }
          }
        }
      }
    }
  }
  catch(Exception e) {
    logger.error(lex, lex.pop, e.toString, e.file ~ ":" ~ Integer.toString(e.line), ["???"]);
  }
}

void parsePath(FilePath path, char[] outputPath) {
  // Create the output path if it doesn't exist
  auto fp = new FilePath(Path.normalize(outputPath));
  fp.create();

  // Parse each file in input path
  foreach(filepath; path) {
    auto fp = new FilePath(filepath.path ~ filepath.name);
    if (fp.isFolder) {
      Stdout("Parsing package ")(filepath.name)("...").newline;
      parsePath(fp, outputPath ~ filepath.name ~ "/");
    }
    else {
      if (filepath.name.length > 4 && filepath.name[$-3..$] == ".di") {
        auto className = filepath.name[0..$-3];
        className = camelCase(className);
        Stdout("-- Parsing class ")(className)(" to ")(outputPath)(filepath.name[0..$-3])(".yaml").newline;
        parseFile(filepath.path ~ filepath.name, outputPath ~ filepath.name[0..$-3] ~ ".yaml");
      }
    }
  }
}

static const char[] USAGE = "Usage: maat <path-to-directory-or-file> <output-path>";

int main(char[][] args) {
  if (args.length < 3) {
    Stdout(USAGE).newline;
    return 0;
  }

  auto filePath = new FilePath(args[1]);

  if (args[2][$-1] != '/') {
    args[2] ~= "/";
  }

  if (filePath.isFile) {
    parseFile(args[1], args[2] ~ "output.yaml");
  }
  else {
    parsePath(new FilePath(args[1]), args[2]);
  }

  return 0;
}
