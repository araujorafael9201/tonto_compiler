%{
// Declarações C++
#include <iostream>
#include <fstream>
#include "tokens.h"

using namespace std;

unsigned long keywordCount = 0, nativeDataTypeCount = 0, classCount = 0, relationshipCount = 0, specialSymbolCount = 0;
unsigned currentColumn = 1;
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
digit [0-9]
number {digit}+(\.{digit}+)?
downcase_letter [a-z]
uppercase_letter [A-Z]
letter {downcase_letter}|{uppercase_letter}
class {uppercase_letter}({letter}|"_")*
relationship {downcase_letter}({letter}|"_")*
%%
  // Regras de tradução
{whitespaces}                 { currentColumn += YYLeng(); }
\n                            { currentColumn = 1; }
genset                        {
                                cout << "PALAVRA RESERVADA | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return GENSET;
                              }
disjoint                      {
                                cout << "PALAVRA RESERVADA | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return DISJOINT;
                              }
complete                      {
                                cout << "PALAVRA RESERVADA | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return COMPLETE;
                              }
general                       {
                                cout << "PALAVRA RESERVADA | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return GENERAL;
                              }
specifics                     {
                                cout << "PALAVRA RESERVADA | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return SPECIFICS;
                              }
where                         {
                                cout << "PALAVRA RESERVADA | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return WHERE;
                              }
package                       {
                                cout << "PALAVRA RESERVADA | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return PACKAGE;
                              }
import                        {
                                cout << "PALAVRA RESERVADA | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return IMPORT;
                              }
functional-complexes          {
                                cout << "PALAVRA RESERVADA | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                keywordCount++;
                                currentColumn += YYLeng();
                                // return FUNCTIONAL_COMPLEXES;
                              }
\{                            {
                                cout << "SÍMBOLO ESPECIAL | ";
                                cout << YYText() << " | line: " << lineno() << " | column: " << currentColumn << endl;
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return L_BRACE;
                              }
\}                            {
                                cout << "SÍMBOLO ESPECIAL | ";
                                cout << YYText() << " | line: " << lineno() << " | column: " << currentColumn << endl;
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return R_BRACE;
                              }
\(                            {
                                cout << "SÍMBOLO ESPECIAL | ";
                                cout << YYText() << " | line: " << lineno() << " | column: " << currentColumn << endl;
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return L_PARAM;
                              }
\)                            {
                                cout << "SÍMBOLO ESPECIAL | ";
                                cout << YYText() << " | line: " << lineno() << " | column: " << currentColumn << endl;
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return R_PARAM;
                              }
\[                            {
                                cout << "SÍMBOLO ESPECIAL | ";
                                cout << YYText() << " | line: " << lineno() << " | column: " << currentColumn << endl;
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return L_BRACKET;
                              }
\]                            {
                                cout << "SÍMBOLO ESPECIAL | ";
                                cout << YYText() << " | line: " << lineno() << " | column: " << currentColumn << endl;
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return R_BRACKET;
                              }
\.\.                          {
                                cout << "SÍMBOLO ESPECIAL | ";
                                cout << YYText() << " | line: " << lineno() << " | column: " << currentColumn << endl;
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return TP;
                              }
\<\>\-\-                      {
                                cout << "SÍMBOLO ESPECIAL | ";
                                cout << YYText() << " | line: " << lineno() << " | column: " << currentColumn << endl;
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return LRO;
                              }
\-\-\<\>                      {
                                cout << "SÍMBOLO ESPECIAL | ";
                                cout << YYText() << " | line: " << lineno() << " | column: " << currentColumn << endl;
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return RRO;
                              }
\*                            {
                                cout << "SÍMBOLO ESPECIAL | ";
                                cout << YYText() << " | line: " << lineno() << " | column: " << currentColumn << endl;
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return ASTERISK;
                              }
\@                            {
                                cout << "SÍMBOLO ESPECIAL | ";
                                cout << YYText() << " | line: " << lineno() << " | column: " << currentColumn << endl;
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return AT;
                              }
\:                            {
                                cout << "SÍMBOLO ESPECIAL | ";
                                cout << YYText() << " | line: " << lineno() << " | column: " << currentColumn << endl;
                                specialSymbolCount++;
                                currentColumn += YYLeng();
                                // return COLON;
                              }
{native_data_type}            {
                                cout << "TIPO DE DADO NATIVO | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                nativeDataTypeCount++;
                                currentColumn += YYLeng();
                                // return NATIVE_DATA_TYPE;
                              }
{class_estereotype}           {
                                cout << "ESTEREÓTIPO DE CLASSE | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                classCount++;
                                currentColumn += YYLeng();
                                // return CLASS_ESTEREOTYPE;
                              }
{relationship_estereotype}    {
                                cout << "ESTERIÓTIPO DE RELAÇÃO | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                relationshipCount++;
                                currentColumn += YYLeng();
                                // return RELATIONSHIP_ESTEREOTYPE;
                              }
{class}                       {
                                cout << "CLASSE | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                currentColumn += YYLeng();
                                // return CLASS_ID
                              }
{relationship}                {
                                  cout << "RELAÇÃO | ";
                                cout << YYText() << " | line: " << lineno() << "| column: " << currentColumn << endl;
                                currentColumn += YYLeng();
                                // return RELATIONSHIP_ID
                              }
.	                            { 
                                cout << "ERRO | Lexema não identificado. | line: " << lineno() << "| column: " << currentColumn << endl;
                                currentColumn += YYLeng(); 
                              }
%%

int main(int argc, char **argv)
{
	yyFlexLexer lexer;
	ifstream fin;

	if (argc > 1)
	{
		fin.open(argv[1]);
		if (!fin.is_open())
		{
			cout << "Arquivo " << argv[1] << " Não pôde ser aberto" << endl;
			exit(EXIT_FAILURE);
		}
		else
		{
			lexer.switch_streams(&fin);
		}
	}
	
	lexer.yylex();
  cout << keywordCount << " Palavras reservadas encontradas" << endl;
  cout << nativeDataTypeCount << " Tipos de dados nativos encontradss" << endl;
	cout << classCount << " Estereótipos de classe encontrados" << endl;
  cout << relationshipCount << " Estereótipos de relação encontrados" << endl;
	fin.close();
}