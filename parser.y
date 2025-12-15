%{
#include <iostream>
#include <FlexLexer.h>
#include <fstream>
#include <vector>
#include "globals.h"

using namespace std;

yyFlexLexer *lexer;

int yylex() { return lexer->yylex(); }

void yyerror(const char *s);

// Variáveis temporárias para construção das estruturas
std::string tempRelStereotype; 
std::string tempGenSetName;
std::vector<std::string> tempSpecificsList;
std::string tempClassStereotype; // Armazena estereótipo da classe sendo lida
bool tempDisjoint = false;       // Flags do genset
bool tempComplete = false;

// Função auxiliar para resetar as flags antes de ler um novo genset
void resetGenFlags() {
    tempDisjoint = false;
    tempComplete = false;
}
%}

%define parse.error verbose

%token UNKNOWN "invalid token"
%token PACKAGE "package" SPECIALIZES "specializes" GENSET "genset" DISJOINT "disjoint" COMPLETE "complete" INCOMPLETE "incomplete" GENERAL "general" OVERLAPPING "overlapping" SPECIFICS "specifics" WHERE "where" IMPORT "import" FUNCTIONAL_COMPLEXES "functional-complexes" DATATYPE "datatype" ENUM "enum" RELATION "relation" 
%token CLASS_ID "class name" RELATION_ID "relation name" INSTANCE_ID "instance name"
%token CLASS_ESTEREOTYPE "class estereotype" RELATION_ESTEREOTYPE "relation estereotype"
%token NATIVE_DATA_TYPE "native data type" NEW_DATA_TYPE "data type"
%token META_ATTR "meta-attribute"
%token L_BRACE "{" R_BRACE "}" COLON ":" AT "@" L_BRACKET "[" R_BRACKET "]" TP ".." ASTERISK "*" LRO "<>--" NRO "--" RRO "--<>" COMMA "," L_PARENTHESIS "(" R_PARENTHESIS ")"
%token NUMBER "number"          
        

%%

start : package body
      | error { yyerrok; } body
      ;

body  : body statement
      |
      ;

statement : class
          | newDataType
          | generalization
          | externalRelation
          | enum
          | error { yyclearin; }
          ;

package : PACKAGE CLASS_ID { packageNames.push_back(currentLexeme); }
        ;

enum  : ENUM CLASS_ID { enumNames.push_back(currentLexeme); } enumBody 
      ;

enumBody  : L_BRACE enumIndividuals R_BRACE
          | L_BRACE error R_BRACE { yyerrok; }
          ;

enumIndividuals : INSTANCE_ID COMMA enumIndividuals
                | INSTANCE_ID
                ;

class : classHeader classBody 
      ;

// Modificado: armazena o estereótipo da classe
classHeader : CLASS_ESTEREOTYPE { tempClassStereotype = currentLexeme; } CLASS_ID {
                currentParsingClass = currentLexeme;
                classNames.push_back(currentLexeme);
                classStereotypes[currentLexeme] = tempClassStereotype; // Mapeia classe -> estereótipo
             }
            ;

classBody : L_BRACE attributes internalRelations R_BRACE
          | SPECIALIZES CLASS_ID
          | error R_BRACE { yyerrok; }
          |
          ;

attributes  : attributes attribute
            |
            ;

attribute : RELATION_ID COLON datatype metaAttribute
          ;

datatype  : NATIVE_DATA_TYPE
          ;

newDataType : newDataTypeHeader newDataTypeBody
            ;

newDataTypeHeader : DATATYPE NEW_DATA_TYPE {
                        newDataTypeNames.push_back(currentLexeme);
                    }
                  ;

newDataTypeBody : L_BRACE attributes R_BRACE
                | L_BRACE error R_BRACE { yyerrok; }
                ;

metaAttribute : L_BRACE META_ATTR R_BRACE
              |
              ;

internalRelations : internalRelations internalRelation
                  | ;

internalRelation  : AT RELATION_ESTEREOTYPE { tempRelStereotype = currentLexeme; } cardinality relationOperator cardinality CLASS_ID
                  {
                      Relation info;
                      info.stereotype = tempRelStereotype;
                      info.sourceClass = currentParsingClass;
                      info.targetClass = currentLexeme;       
                      info.isExternal = false;
                      relationsList.push_back(info);
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
                  }
                  ;

cardinality : L_BRACKET cardinalityBody R_BRACKET
            ;

cardinalityBody : NUMBER cardinalityEnding
                ;

cardinalityEnding : TP ASTERISK
                  | ;

// Ação vazia antes das alternativas para garantir reset das flags
generalization : { resetGenFlags(); } generalizationOptions
               ;

generalizationOptions : inlineGeneralization
                      | blockGeneralization
                      ;

inlineGeneralization  : generalizationHeader WHERE { tempSpecificsList.clear(); } generalizationSpecifics SPECIALIZES CLASS_ID 
                      {
                          Generalization info;
                          info.name = tempGenSetName;
                          info.generalClass = currentLexeme;
                          info.specificClasses = tempSpecificsList;
                          info.isInline = true;
                          info.isDisjoint = tempDisjoint; // Salva flags
                          info.isComplete = tempComplete;
                          generalizationsList.push_back(info);
                      }
                      ;

generalizationHeader : generalizationRestrictions GENSET CLASS_ID { tempGenSetName = currentLexeme; } 
                     ;

// Captura as restrições
generalizationRestrictions : DISJOINT { tempDisjoint = true; } generalizationRestrictions
                           | OVERLAPPING { tempDisjoint = false; } generalizationRestrictions
                           | COMPLETE { tempComplete = true; } generalizationRestrictions
                           | INCOMPLETE { tempComplete = false; } generalizationRestrictions
                           | ;

generalizationSpecifics : CLASS_ID { tempSpecificsList.push_back(currentLexeme); } COMMA generalizationSpecifics
                        | CLASS_ID { tempSpecificsList.push_back(currentLexeme); }
                        ;

blockGeneralization : generalizationHeader generalizationBody
                    ;

generalizationBody  : L_BRACE GENERAL CLASS_ID { currentParsingClass = currentLexeme; } SPECIFICS { tempSpecificsList.clear(); } generalizationSpecifics R_BRACE
                    {
                        Generalization info;
                        info.name = tempGenSetName;
                        info.generalClass = currentParsingClass;
                        info.specificClasses = tempSpecificsList;
                        info.isInline = false;
                        info.isDisjoint = tempDisjoint; // Salva flags
                        info.isComplete = tempComplete;
                        generalizationsList.push_back(info);
                    }
                    | L_BRACE error R_BRACE { yyerrok; }
                    ;

relationOperator  : LRO
                  | NRO
                  | RRO
                  ;

%%

int main(int argc, char **argv)
{
    if (argc < 2) {
        cerr << "Uso: " << argv[0] << " <arquivo1.tonto> [arquivo2.tonto ...]" << endl;
        return 1;
    }

    for (int i = 1; i < argc; ++i) {
        string inputFilename = argv[i];
        ifstream fin(inputFilename);

        if (!fin.is_open()) {
            cerr << "Arquivo " << inputFilename << " não pôde ser aberto." << endl;
            continue;
        }

        // Reinicia o estado global
        resetGlobals();
        
        lexer = new yyFlexLexer(&fin);

        string baseName = inputFilename;
        size_t lastDot = baseName.find_last_of(".");
        if (lastDot != string::npos) {
            baseName = baseName.substr(0, lastDot);
        }
        
        string analyticLogName = baseName + "_analytic.log";
        string syntheticLogName = baseName + "_synthetic.log";

        outputAnalyticData.open(analyticLogName);
        outputSyntheticData.open(syntheticLogName);

        if (!outputAnalyticData.is_open() || !outputSyntheticData.is_open()) {
             cerr << "Erro ao criar arquivos de log para " << inputFilename << endl;
             delete lexer;
             fin.close();
             continue;
        }

        cout << "Processing: " << inputFilename << endl;
        if (yyparse() == 0) {
            flushSyntacticLog();
            
            // EXECUTA A ANÁLISE SEMÂNTICA
            performSemanticAnalysis();
            
            cout << "Logs: " << analyticLogName << ", " << syntheticLogName << endl << endl;
        } else {
            cerr << "Error " << inputFilename << endl;
        }

        outputAnalyticData.close();
        outputSyntheticData.close();
        
        delete lexer;
        fin.close();
    }

    return 0;
}

void yyerror(const char *s)
{
    cerr << s << " (\"" << lexer->YYText() << "\" at line " << lexer->lineno() << ", column " << lastTokenColumn << ")\n";
}