%{
// Declarações C++
#include <iostream>
#include <fstream>
#include <string>
#include "tokens.h"

using namespace std;

ofstream outputAnalyticData;
ofstream outputSyntheticData;

unsigned long keywordCount = 0, nativeDataTypeCount = 0, metaAttrCount = 0, specialSymbolCount = 0,
              classEsterotypeCount = 0, relationshipEstereotypeCount = 0,
              classIdCount = 0, relationshipIdCount = 0, instanceIdCount = 0, newDataTypeIdCount = 0,
              numericConstantCount = 0;
int currentColumn = 1;

void logAnalyticData(int token, const string& type, const char* lexeme, int line, int column);
%}

 // Opções do Flex
%option noyywrap
%option yylineno

 // Definições regulares
delim [ \t]
whitespaces {delim}+
class_estereotype  event|situation|pry|mixin|phaseMixin|roleMixin|historicalRoleMixin|kind|collective|quantity|quality|mode|intrisicMode|extrinsicMode|subkind|phase|role|historicalRole     
relationship_estereotype material|derivation|comparative|mediation|characterization|externalDependence|componentOf|memberOf|subCollectionOf|subQualityOf|instantiation|termination|participational|participation|historicalDependence|creation|manifestation|bringsAbout|triggers|composition|aggregation|inherence|value|formal|constitution
native_data_type number|string|boolean|date|time|datetime
meta_attr ordered|const|derived|subsets|redefines
digit [0-9]
number {digit}+(\.{digit}+)?
downcase_letter [a-z]
uppercase_letter [A-Z]
letter {downcase_letter}|{uppercase_letter}
new_data_type {letter}+DataType
class {uppercase_letter}({letter}|"_")*
relationship {downcase_letter}({letter}|"_")*
instance {letter}({letter}|"_")*{digit}+
%%
  // Regras de tradução
{whitespaces}                 { currentColumn += YYLeng(); }
\n                            { currentColumn = 1; }
genset                        {
                                logAnalyticData(GENSET, "Palavra Reservada", YYText(), lineno(), currentColumn);
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return GENSET;
                              }
disjoint                      {
                                logAnalyticData(DISJOINT, "Palavra Reservada", YYText(), lineno(), currentColumn);
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return DISJOINT;
                              }
complete                      {
                                logAnalyticData(COMPLETE, "Palavra Reservada", YYText(), lineno(), currentColumn);
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return COMPLETE;
                              }
general                       {
                                logAnalyticData(GENERAL, "Palavra Reservada", YYText(), lineno(), currentColumn);
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return GENERAL;
                              }
specifics                     {
                                logAnalyticData(SPECIFICS, "Palavra Reservada", YYText(), lineno(), currentColumn);
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return SPECIFICS;
                              }
where                         {
                                logAnalyticData(WHERE, "Palavra Reservada", YYText(), lineno(), currentColumn);
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return WHERE;
                              }
package                       {
                                logAnalyticData(PACKAGE, "Palavra Reservada", YYText(), lineno(), currentColumn);
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return PACKAGE;
                              }
import                        {
                                logAnalyticData(IMPORT, "Palavra Reservada", YYText(), lineno(), currentColumn);
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return IMPORT;
                              }
functional-complexes          {
                                logAnalyticData(FUNCTIONAL_COMPLEXES, "Palavra Reservada", YYText(), lineno(), currentColumn);
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return FUNCTIONAL_COMPLEXES;
                              }
\{                            {
                                logAnalyticData(L_BRACE, "Símbolo Especial", YYText(), lineno(), currentColumn);
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return L_BRACE;
                              }
\}                            {
                                logAnalyticData(R_BRACE, "Símbolo Especial", YYText(), lineno(), currentColumn);
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return R_BRACE;
                              }
\(                            {
                                logAnalyticData(L_PARENTHESIS, "Símbolo Especial", YYText(), lineno(), currentColumn);
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return L_PARENTHESIS;
                              }
\)                            {
                                logAnalyticData(R_PARENTHESIS, "Símbolo Especial", YYText(), lineno(), currentColumn);
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return R_PARENTHESIS;
                              }
\[                            {
                                logAnalyticData(L_BRACKET, "Símbolo Especial", YYText(), lineno(), currentColumn);
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return L_BRACKET;
                              }
\]                            {
                                logAnalyticData(R_BRACKET, "Símbolo Especial", YYText(), lineno(), currentColumn);
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return R_BRACKET;
                              }
\.\.                          {
                                logAnalyticData(TP, "Símbolo Especial", YYText(), lineno(), currentColumn);
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return TP;
                              }
\<\>\-\-                      {
                                logAnalyticData(LRO, "Símbolo Especial", YYText(), lineno(), currentColumn);
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return LRO;
                              }
\-\-\<\>                      {
                                logAnalyticData(RRO, "Símbolo Especial", YYText(), lineno(), currentColumn);
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return RRO;
                              }
\*                            {
                                logAnalyticData(ASTERISK, "Símbolo Especial", YYText(), lineno(), currentColumn);
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return ASTERISK;
                              }
\@                            {
                                logAnalyticData(AT, "Símbolo Especial", YYText(), lineno(), currentColumn);
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return AT;
                              }
\:                            {
                                logAnalyticData(COLON, "Símbolo Especial", YYText(), lineno(), currentColumn);
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return COLON;
                              }
{number}                      {
                                logAnalyticData(NUM, "Constante Numérica", YYText(), lineno(), currentColumn);
                                numericConstantCount++;
                                currentColumn += YYLeng();
                                // return NUM;
                              }                    
{native_data_type}            {
                                logAnalyticData(NATIVE_DATA_TYPE, "Tipo de dado nativo", YYText(), lineno(), currentColumn);
                                nativeDataTypeCount++;
                                currentColumn += YYLeng();
                                // return NATIVE_DATA_TYPE;
                              }
{class_estereotype}           {
                                logAnalyticData(CLASS_ESTEREOTYPE, "Esteriótipo de classe", YYText(), lineno(), currentColumn);
                                classEsterotypeCount++;
                                currentColumn += YYLeng();
                                // return CLASS_ESTEREOTYPE;
                              }
{relationship_estereotype}    {
                                logAnalyticData(RELATIONSHIP_ESTEREOTYPE, "Esteriótipo de relação", YYText(), lineno(), currentColumn);
                                relationshipEstereotypeCount++;
                                currentColumn += YYLeng();
                                // return RELATIONSHIP_ESTEREOTYPE;
                              }
{meta_attr}                   {
                                logAnalyticData(META_ATTR, "Meta-atributo", YYText(), lineno(), currentColumn);
                                metaAttrCount++;
                                currentColumn += YYLeng();
                                // return META_ATTR;
                              }
{new_data_type}               {
                                logAnalyticData(NEW_DATA_TYPE, "Novo tipo de dado", YYText(), lineno(), currentColumn);
                                newDataTypeIdCount++;
                                currentColumn += YYLeng();
                                // return NEW_DATA_TYPE
                              }
{class}                       {
                                logAnalyticData(CLASS_ID, "Identificador de classe", YYText(), lineno(), currentColumn);
                                classIdCount++;
                                currentColumn += YYLeng();
                                // return CLASS_ID
                              }
{relationship}                {
                                logAnalyticData(RELATIONSHIP_ID, "Identificador de relação", YYText(), lineno(), currentColumn);
                                relationshipIdCount++;
                                currentColumn += YYLeng();
                                // return RELATIONSHIP_ID
                              }
{instance}                    {
                                logAnalyticData(INSTANCE_ID, "Identificador de instância", YYText(), lineno(), currentColumn);
                                instanceIdCount++;
                                currentColumn += YYLeng();
                                // return INSTANCE_ID
                              }
.	                            { 
                                cerr << "ERRO LÉXICO: Lexema \"" << YYText() << "\" inválido. | line: " << lineno() << " | column: " << currentColumn << endl;
                              }
%%

int main(int argc, char **argv)
{
	yyFlexLexer lexer;
	ifstream fin;

  outputAnalyticData.open("analyticData.log");
  if (!outputAnalyticData.is_open()) {
      cerr << "Erro: Não foi possível criar o arquivo de dados analíticos." << endl;
      return EXIT_FAILURE;
  }

	if (argc > 1)
	{
		fin.open(argv[1]);
		if (!fin.is_open())
		{
			cerr << "Arquivo " << argv[1] << " Não pôde ser aberto" << endl;
			exit(EXIT_FAILURE);
		}
		else
		{
			lexer.switch_streams(&fin);
		}
	}
	
	lexer.yylex();

	fin.close();
  outputAnalyticData.close();

  outputSyntheticData.open("syntheticData.log");
  if (!outputSyntheticData.is_open()) {
      cerr << "Erro: Não foi possível criar o arquivo de dados de síntese." << endl;
      return EXIT_FAILURE;
  }


  outputSyntheticData << "Palavras Reservadas: " << keywordCount << '\n'
                      << "Tipos de dados nativos: " << nativeDataTypeCount << '\n'
                      << "Meta-atributos: " << metaAttrCount << '\n'
                      << "Símbolos especiais: " << specialSymbolCount << '\n'
                      << "Estereótipos de classe: " << classEsterotypeCount << '\n'
                      << "Estereótipos de relação: " << relationshipEstereotypeCount << '\n'
                      << "Identificadores de classe: " << classIdCount << '\n'
                      << "Identificadores de relação: " << relationshipIdCount << '\n'
                      << "Identificadores de instância: " << instanceIdCount << '\n'
                      << "Identificadores de novo tipo de dado: " << newDataTypeIdCount << '\n'
                      << "Constantes numéricas: " << numericConstantCount << '\n';

  outputSyntheticData.close();

  return 0;
}

void logAnalyticData(int token, const string& type, const char* lexeme, int line, int column)
{
  if(outputAnalyticData.is_open()){
    outputAnalyticData << "token: " << token << " | lexeme: " << lexeme << " | type: " << type << " | line: " << line << " | column: " << column << endl;
  }
}
