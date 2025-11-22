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

%token GENSET DISJOINT COMPLETE GENERAL SPECIFICS WHERE PACKAGE IMPORT FUNCTIONAL_COMPLEXES NUM CLASS_ESTEREOTYPE RELATIONSHIP_ESTEREOTYPE NATIVE_DATA_TYPE NEW_DATA_TYPE META_ATTR CLASS_ID RELATIONSHIP_ID INSTANCE_ID L_BRACE R_BRACE L_PARENTHESIS R_PARENTHESIS L_BRACKET R_BRACKET TP LRO RRO ASTERISK AT COLON

%%

start:
    | start package
    ;

package:
      PACKAGE CLASS_ID {
          cout << "Declaração de Pacote\n";
      }
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
    cerr << "Erro sintático: \"" << lexer.YYText()
         << "\" (linha " << lexer.lineno()
         << ", coluna " << lastTokenColumn << ")\n";
}
