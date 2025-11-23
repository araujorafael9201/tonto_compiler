%{
#include <iostream>
#include <FlexLexer.h>
#include <fstream>
#include "globals.h"

using namespace std;

yyFlexLexer lexer;

int yylex() { return lexer.yylex(); }

void yyerror(const char *s);
%}

%define parse.error verbose

%token PACKAGE "package" SPECIALIZES "specializes"
%token CLASS_ID "class name" RELATION_ID "relation name"
%token CLASS_ESTEREOTYPE "class estereotype" RELATION_ESTEREOTYPE "relation estereotype"
%token NATIVE_DATA_TYPE "native data type" NEW_DATA_TYPE "data type"
%token META_ATTR "meta-attribute"
%token L_BRACE "{" R_BRACE "}" COLON ":" AT "@" L_BRACKET "[" R_BRACKET "]" TP ".." ASTERISK "*" LRO "<>--" NRO "--" RRO "--<>" 
%token NUMBER "number"
%token GENSET DISJOINT COMPLETE GENERAL SPECIFICS WHERE IMPORT FUNCTIONAL_COMPLEXES DATATYPE ENUM RELATION INSTANCE_ID L_PARENTHESIS R_PARENTHESIS   

%%

start : package body
      ;

body  : body statement
      |
      ;
  
statement : class
          ;

package : PACKAGE CLASS_ID { cout << "Declaração de Pacote\n"; }
        ;

class : classHeader classBody { cout << "Declaração de Classe\n"; }
      ;

classHeader : CLASS_ESTEREOTYPE CLASS_ID
            ;

classBody : L_BRACE attributes internalRelations R_BRACE
          | SPECIALIZES CLASS_ID
          ;

attributes  : attributes attribute
            |
            ; 

attribute : RELATION_ID COLON datatype metaAttribute
          ;

datatype  : NATIVE_DATA_TYPE
          | NEW_DATA_TYPE
          ;

metaAttribute : L_BRACE META_ATTR R_BRACE
              |
              ;

internalRelations : internalRelations internalRelation
                  |

internalRelation  : AT RELATION_ESTEREOTYPE cardinality relationOperator cardinality CLASS_ID { cout << "Declaração de Relação Interna\n"; }
                  ;

cardinality : L_BRACKET cardinalityBody R_BRACKET
            ;

cardinalityBody : NUMBER cardinalityEnding
                  ;

cardinalityEnding : TP ASTERISK
                  |
                  ;

relationOperator  : LRO
                  | NRO
                  | RRO
                  ;

%%

int main(int argc, char **argv)
{
    ifstream fin;

    if (argc > 1) {
        fin.open(argv[1]);
        if (!fin.is_open()) {
            cerr << "Arquivo " << argv[1] << " Não pôde ser aberto" << endl;
            return 1;
        }
        lexer.switch_streams(&fin);
    }

    outputAnalyticData.open("analyticData.log");
    outputSyntheticData.open("syntheticData.log");

    int result = yyparse();

    flushSyntheticLog();

    outputAnalyticData.close();
    outputSyntheticData.close();

    return result;
}

void yyerror(const char *s)
{
    cerr << s << " (line " << lexer.lineno() << ", column " << lastTokenColumn << ")\n";
}
