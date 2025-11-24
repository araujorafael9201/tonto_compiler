%{
#include <iostream>
#include <FlexLexer.h>
#include <fstream>
#include <vector>
#include "globals.h"

using namespace std;

yyFlexLexer lexer;

int yylex() { return lexer.yylex(); }

void yyerror(const char *s);

std::string tempRelStereotype; // Armazena temporariamente o último estereótipo de relação lido
std::string tempGenSetName;
std::vector<std::string> tempSpecificsList;
%}

%define parse.error verbose

%token PACKAGE "package" SPECIALIZES "specializes"
%token CLASS_ID "class name" RELATION_ID "relation name"
%token CLASS_ESTEREOTYPE "class estereotype" RELATION_ESTEREOTYPE "relation estereotype"
%token NATIVE_DATA_TYPE "native data type" NEW_DATA_TYPE "data type"
%token META_ATTR "meta-attribute"
%token L_BRACE "{" R_BRACE "}" COLON ":" AT "@" L_BRACKET "[" R_BRACKET "]" TP ".." ASTERISK "*" LRO "<>--" NRO "--" RRO "--<>" COMMA ","
%token NUMBER "number"
%token GENSET DISJOINT COMPLETE INCOMPLETE GENERAL OVERLAPPING SPECIFICS WHERE IMPORT FUNCTIONAL_COMPLEXES DATATYPE ENUM RELATION INSTANCE_ID L_PARENTHESIS R_PARENTHESIS   

%%

start : package body
      ;

body  : body statement
      |
      ;
  
statement : class
          | newDataType
          | generalization
          | externalRelation
          | enum
          ;

package : PACKAGE CLASS_ID { packageNames.push_back(currentLexeme); cout << "Declaração de Pacote: " << currentLexeme << "\n"; }
        ;

enum  : ENUM CLASS_ID { enumNames.push_back(currentLexeme); } enumBody { cout << "Declaração de ENUM\n"; }
      ;

enumBody : L_BRACE enumIndividuals R_BRACE
         ;

enumIndividuals : INSTANCE_ID COMMA enumIndividuals
                | INSTANCE_ID
                ;

class : classHeader classBody { cout << "Declaração de Classe\n"; }
      ;

classHeader : CLASS_ESTEREOTYPE CLASS_ID {
                currentParsingClass = currentLexeme; // Salva contexto para relações internas
                classNames.push_back(currentLexeme);
            }
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
          ;

newDataType : newDataTypeHeader newDataTypeBody { cout << "Declaração de Novo Tipo de Dados\n"; }
            ;

newDataTypeHeader : DATATYPE NEW_DATA_TYPE {
                        newDataTypeNames.push_back(currentLexeme);
                  }
                  ;

newDataTypeBody : L_BRACE attributes R_BRACE
                ;

metaAttribute : L_BRACE META_ATTR R_BRACE
              |
              ;

internalRelations : internalRelations internalRelation
                  |
                  ;

/* Relação Interna: A classe origem é 'currentParsingClass', o alvo é o último CLASS_ID lido */
internalRelation  : AT RELATION_ESTEREOTYPE { tempRelStereotype = currentLexeme; } cardinality relationOperator cardinality CLASS_ID
    {
        Relation info;
        info.stereotype = tempRelStereotype;
        info.sourceClass = currentParsingClass;
        info.targetClass = currentLexeme;       // O último token lido foi o ID da classe alvo
        info.isExternal = false;
        relationsList.push_back(info);
        cout << "Declaração de Relação Interna\n"; 
    }
                  ;

externalRelation  : AT RELATION_ESTEREOTYPE { tempRelStereotype = currentLexeme; } RELATION CLASS_ID { currentParsingClass = currentLexeme; } cardinality relationOperator cardinality CLASS_ID 
    {
        Relation info;
        info.stereotype = tempRelStereotype;
        info.sourceClass = currentParsingClass;
        info.targetClass = currentLexeme;
        info.isExternal = true;
        relationsList.push_back(info);
        cout << "Declaração de Relação Externa\n"; 
    }
                  ;

cardinality : L_BRACKET cardinalityBody R_BRACKET
            ;

cardinalityBody : NUMBER cardinalityEnding
                ;

cardinalityEnding : TP ASTERISK
                  |
                  ;

generalization : inlineGeneralization
               | blockGeneralization
               ;

inlineGeneralization  : generalizationHeader WHERE { tempSpecificsList.clear(); } generalizationSpecifics SPECIALIZES CLASS_ID 
    {
        Generalization info;
        info.name = tempGenSetName;
        info.generalClass = currentLexeme; // O ID logo após SPECIALIZES, classe geral
        info.specificClasses = tempSpecificsList;
        info.isInline = true;
        generalizationsList.push_back(info);
        cout << "Generalização em Linha\n";
    }
                      ;

generalizationHeader : generalizationRestrictions GENSET CLASS_ID { tempGenSetName = currentLexeme; } // Atualiza nome da generalização atual
                     ;

generalizationRestrictions : DISJOINT generalizationRestrictions
                           | OVERLAPPING generalizationRestrictions
                           | COMPLETE generalizationRestrictions
                           | INCOMPLETE generalizationRestrictions
                           |
                           ;

generalizationSpecifics : CLASS_ID { tempSpecificsList.push_back(currentLexeme); } COMMA generalizationSpecifics
                        | CLASS_ID { tempSpecificsList.push_back(currentLexeme); }
                        ;

blockGeneralization : generalizationHeader generalizationBody { cout << "Generalização em Bloco\n"; }
                    ;

// Aqui se utiliza currentParsingClass para manter uma referência ao nome da classe geral da generalização atual
generalizationBody  : L_BRACE GENERAL CLASS_ID { currentParsingClass = currentLexeme; } SPECIFICS { tempSpecificsList.clear(); } generalizationSpecifics R_BRACE
    {
        Generalization info;
        info.name = tempGenSetName;
        info.generalClass = currentParsingClass;
        info.specificClasses = tempSpecificsList;
        info.isInline = false;
        generalizationsList.push_back(info);
    }
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

    flushSyntacticLog();

    outputAnalyticData.close();
    outputSyntheticData.close();

    return result;
}

void yyerror(const char *s)
{
    cerr << s << " (\"" << lexer.YYText() << "\" at line " << lexer.lineno() << ", column " << lastTokenColumn << ")\n";
}
