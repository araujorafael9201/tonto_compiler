%{
// Declarações C++
#include <iostream>
#include <fstream>
#include "tokens.h"

using namespace std;

int keywordCount = 0;
int nativeDataTypeCount = 0;
int classCount = 0;
int relationshipCount = 0;
%}

 // Opções do Flex
%option noyywrap
%option yylineno

 // Definições regulares
class_estereotype  event|situation|pry|mixin|phaseMixin|roleMixin|historicalRoleMixin|kind|collective|quantity|quality|mode|intrisicMode|extrinsicMode|subkind|phase|role|historicalRole     
relationship_estereotype material|derivation|comparative|mediation|characterization|externalDependence|componentOf|memberOf|subCollectionOf|subQualityOf|instantiation|termination|participational|participation|historicalDependence|creation|manifestation|bringsAbout|triggers|composition|aggregation|inherence|value|formal|constitution
native_data_type number|string|boolean|date|time|datetime  
%%
  // Regras de tradução
genset                        {
                                cout << YYText() << " on line " << lineno() << endl;
                                keywordCount++;
                                // return GENSET;
                              }
disjoint                      {
                                cout << YYText() << " on line " << lineno() << endl;
                                keywordCount++;
                                // return DISJOINT;
                              }
complete                      {
                                cout << YYText() << " on line " << lineno() << endl;
                                keywordCount++;
                                // return COMPLETE;
                              }
general                       {
                                cout << YYText() << " on line " << lineno() << endl;
                                keywordCount++;
                                // return GENERAL;
                              }
specifics                     {
                                cout << YYText() << " on line " << lineno() << endl;
                                keywordCount++;
                                // return SPECIFICS;
                              }
where                         {
                                cout << YYText() << " on line " << lineno() << endl;
                                keywordCount++;
                                // return WHERE;
                              }
package                       {
                                cout << YYText() << " on line " << lineno() << endl;
                                keywordCount++;
                                // return PACKAGE;
                              }
import                        {
                                cout << YYText() << " on line " << lineno() << endl;
                                keywordCount++;
                                // return IMPORT;
                              }
functional-complexes          {
                                cout << YYText() << " on line " << lineno() << endl;
                                keywordCount++;
                                // return FUNCTIONAL_COMPLEXES;
                              }
{native_data_type}            {
                                cout << YYText() << " on line " << lineno() << endl;
                                classCount++;
                                // return NATIVE_DATA_TYPE;
                              }
{class_estereotype}           {
                                cout << YYText() << " on line " << lineno() << endl;
                                classCount++;
                                // return CLASS_ESTEREOTYPE;
                              }
{relationship_estereotype}    {
                                cout << YYText() << " on line " << lineno() << endl;
                                // return RELATIONSHIP_ESTEREOTYPE;
                              }
.|\n	                        ;
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
  cout << keywordCount << " Palavras-chave encontradss" << endl;
  cout << nativeDataTypeCount << " Palavras-chave encontradss" << endl;
	cout << classCount << " Estereótipos de classe encontrados" << endl;
  cout << relationshipCount << " Estereótipos de relação encontrados" << endl;
	fin.close();
}