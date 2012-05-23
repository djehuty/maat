/*
 * attribute_unit.d
 *
 */

module syntax.attribute_unit;

import syntax.declaration_unit;

import ast.declaration_node;
import ast.type_declaration_node;

import lex.lexer;
import lex.token;
import logger;

class AttributeUnit {
public:
  enum Attribute {
    Static,
    Extern,
    Deprecated,
    Final,
    Synchronized,
    Override,
    Abstract,
    Const,
    Auto,
    Scope,
    Align,
    Pragma,
    Public,
    Protected,
    Private,
    Package
  }

private:
  Lexer  _lexer;
  Logger _logger;

  int _state;

  DeclarationNode _declaration;
  Attribute[] _attributes;

  // Put in AST node
  void _addAttributeIfUnique(Attribute attribute) {
    bool shouldAdd = true;
    foreach(attr; _attributes) {
      if (attr == attribute) {
        shouldAdd = false;
        break;
      }
    }

    if (shouldAdd) {
      _attributes ~= attribute;
    }
  }

public:
  this(Lexer lexer, Logger logger) {
    _lexer = lexer;
    _logger = logger;
  }

  DeclarationNode parse() {
    Token token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    return _declaration;
  }

  bool tokenFound(Token token) {
    if (_state > 0) {
      switch (token.type) {
        case Token.Type.LeftParen:
          _state = 1;
          break;

        case Token.Type.Identifier:
          _state = 2;
          break;

        case Token.Type.Increment:
          _state = 2;
          break;

        case Token.Type.RightParen:
          _state = 0;
          break;
      }
      return true;
    }

    switch(token.type) {
      case Token.Type.Static:
        _addAttributeIfUnique(Attribute.Static);
        return true;

      case Token.Type.Const:
        _addAttributeIfUnique(Attribute.Const);
        return true;

      case Token.Type.Public:
        _addAttributeIfUnique(Attribute.Public);
        return true;

      case Token.Type.Private:
        _addAttributeIfUnique(Attribute.Private);
        return true;

      case Token.Type.Protected:
        _addAttributeIfUnique(Attribute.Protected);
        return true;

      case Token.Type.Package:
        _addAttributeIfUnique(Attribute.Package);
        return true;

      case Token.Type.Synchronized:
        _addAttributeIfUnique(Attribute.Synchronized);
        return true;

      case Token.Type.Deprecated:
        _addAttributeIfUnique(Attribute.Deprecated);
        return true;

      case Token.Type.Override:
        _addAttributeIfUnique(Attribute.Override);
        return true;

      case Token.Type.Final:
        _addAttributeIfUnique(Attribute.Final);
        return true;

      case Token.Type.Extern:
        _addAttributeIfUnique(Attribute.Extern);
        _state = 1;
        // TODO: extern ( x ) // Do parens list
        return true;

      case Token.Type.Scope:
        // TODO: scope ( x ) // Do parens list
        _addAttributeIfUnique(Attribute.Extern);
        return true;

      case Token.Type.Colon:
        if (_attributes.length == 0) {
          _logger.error(_lexer, token,
              "Attribute list is empty.",
              "Did you mean to place 'public' or 'private' (etc) here?",
              ["public:", "private:", "public static:"]);
        }

        // Done
        return false;

      default:
        break;
    }

    // Followed by declaration
    _lexer.push(token);
    _declaration = (new DeclarationUnit(_lexer, _logger)).parse;
    return false;
  }
}
