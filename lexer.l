%{
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <parser.h>
#include "globals.h"

using namespace std;
%}

%option noyywrap
%option yylineno

delim [ \t]
whitespaces {delim}+
class_estereotype event|situation|pry|mixin|phaseMixin|roleMixin|historicalRoleMixin|kind|collective|quantity|quality|mode|intrisicMode|extrinsicMode|subkind|phase|role|historicalRole
relation_estereotype material|derivation|comparative|mediation|characterization|externalDependence|componentOf|memberOf|subCollectionOf|subQualityOf|instantiation|termination|participational|participation|historicalDependence|creation|manifestation|bringsAbout|triggers|composition|aggregation|inherence|value|formal|constitution
native_data_type number|string|boolean|date|time|datetime
meta_attr ordered|const|derived|subsets|redefines
digit [0-9]
downcase_letter [a-z]
uppercase_letter [A-Z]
letter {downcase_letter}|{uppercase_letter}
new_data_type {letter}+DataType
class {uppercase_letter}({letter}|"_")*
relation {downcase_letter}({letter}|"_")*
instance {letter}({letter}|"_")*{digit}+

%%

{whitespaces}               { currentColumn += YYLeng(); }
\n                          { currentColumn = 1; }
genset                      {
                              logAnalyticData(GENSET, "Palavra Reservada", YYText(), lineno(), currentColumn);
                              keywordCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return GENSET;
                            }
disjoint                    {
                              logAnalyticData(DISJOINT, "Palavra Reservada", YYText(), lineno(), currentColumn);
                              keywordCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return DISJOINT;
                            }
complete                    {
                              logAnalyticData(COMPLETE, "Palavra Reservada", YYText(), lineno(), currentColumn);
                              keywordCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return COMPLETE;
                            }
general                     {
                              logAnalyticData(GENERAL, "Palavra Reservada", YYText(), lineno(), currentColumn);
                              keywordCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return GENERAL;
                            }
specifics                   {
                              logAnalyticData(SPECIFICS, "Palavra Reservada", YYText(), lineno(), currentColumn);
                              keywordCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return SPECIFICS;
                            }
where                       {
                              logAnalyticData(WHERE, "Palavra Reservada", YYText(), lineno(), currentColumn);
                              keywordCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return WHERE;
                            }
package                     {
                              logAnalyticData(PACKAGE, "Palavra Reservada", YYText(), lineno(), currentColumn);
                              keywordCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return PACKAGE;
                            }
import                      {
                                logAnalyticData(IMPORT, "Palavra Reservada", YYText(), lineno(), currentColumn);
                                keywordCount++;
                                lastTokenColumn = currentColumn;  
                                currentColumn += YYLeng();
                                return IMPORT;
                            }
functional-complexes        {
                              logAnalyticData(FUNCTIONAL_COMPLEXES, "Palavra Reservada", YYText(), lineno(), currentColumn);
                              keywordCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return FUNCTIONAL_COMPLEXES;
                            }
datatype                    {
                              logAnalyticData(DATATYPE, "Palavra Reservada", YYText(), lineno(), currentColumn);
                              keywordCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return DATATYPE;
                            }
enum                        {
                              logAnalyticData(ENUM, "Palavra Reservada", YYText(), lineno(), currentColumn);
                              keywordCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return ENUM;
                            }
relation                    {
                              logAnalyticData(RELATION, "Palavra Reservada", YYText(), lineno(), currentColumn);
                              keywordCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return RELATION;
                            }
specializes                 {
                              logAnalyticData(SPECIALIZES, "Palavra Reservada", YYText(), lineno(), currentColumn);
                              keywordCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return SPECIALIZES;
                            }
\{                          { 
                              logAnalyticData(L_BRACE,"Símbolo Especial",YYText(),lineno(),currentColumn); 
                              specialSymbolCount++; 
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng();
                              return L_BRACE; 
                            }
\}                          {
                              logAnalyticData(R_BRACE,"Símbolo Especial",YYText(),lineno(),currentColumn);
                              specialSymbolCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng(); 
                              return R_BRACE; 
                            }
\(                          {
                              logAnalyticData(L_PARENTHESIS,"Símbolo Especial",YYText(),lineno(),currentColumn);
                              specialSymbolCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng();
                              return L_PARENTHESIS;
                            }
\)                          {
                              logAnalyticData(R_PARENTHESIS,"Símbolo Especial",YYText(),lineno(),currentColumn); 
                              specialSymbolCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng();
                              return R_PARENTHESIS;
                            }
\[                          {
                              logAnalyticData(L_BRACKET,"Símbolo Especial",YYText(),lineno(),currentColumn);
                              specialSymbolCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng();
                              return L_BRACKET;
                            }
\]                          {
                              logAnalyticData(R_BRACKET,"Símbolo Especial",YYText(),lineno(),currentColumn);
                              specialSymbolCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng();
                              return R_BRACKET;
                            }
\.\.                        {
                              logAnalyticData(TP,"Símbolo Especial",YYText(),lineno(),currentColumn);
                              specialSymbolCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng();
                              return TP;
                            }
\<\>\-\-                    {
                              logAnalyticData(LRO,"Símbolo Especial",YYText(),lineno(),currentColumn);
                              specialSymbolCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng();
                              return LRO;
                            }
\-\-                        {
                              logAnalyticData(NRO,"Símbolo Especial",YYText(),lineno(),currentColumn);
                              specialSymbolCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng();
                              return NRO;
                            }
\-\-\<\>                    { 
                              logAnalyticData(RRO,"Símbolo Especial",YYText(),lineno(),currentColumn);
                              specialSymbolCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng();
                              return RRO;
                            }
\*                          {
                              logAnalyticData(ASTERISK,"Símbolo Especial",YYText(),lineno(),currentColumn);
                              specialSymbolCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng();
                              return ASTERISK;
                            }
\@                          {
                              logAnalyticData(AT,"Símbolo Especial",YYText(),lineno(),currentColumn);
                              specialSymbolCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng();
                              return AT;
                            }
\:                          {
                              logAnalyticData(COLON,"Símbolo Especial",YYText(),lineno(),currentColumn);
                              specialSymbolCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng(); 
                              return COLON; 
                            }
\,                          {
                              logAnalyticData(COMMA,"Símbolo Especial",YYText(),lineno(),currentColumn);
                              specialSymbolCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn+=YYLeng(); 
                              return COMMA; 
                            }
{digit}                    {
                              logAnalyticData(NUMBER,"Número",YYText(),lineno(),currentColumn);
                              numberCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return NUMBER;
                            }
{native_data_type}          {
                              logAnalyticData(NATIVE_DATA_TYPE,"Tipo de dado nativo",YYText(),lineno(),currentColumn);
                              nativeDataTypeCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return NATIVE_DATA_TYPE;
                            }
{class_estereotype}         {
                              logAnalyticData(CLASS_ESTEREOTYPE,"Estereótipo de classe",YYText(),lineno(),currentColumn);
                              classEsterotypeCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              currentLexeme = YYText();
                              return CLASS_ESTEREOTYPE;
                            }
{relation_estereotype}  {
                              logAnalyticData(RELATION_ESTEREOTYPE,"Estereótipo de relação",YYText(),lineno(),currentColumn);
                              relationEstereotypeCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              currentLexeme = YYText();
                              return RELATION_ESTEREOTYPE;
                            }
{meta_attr}                 {
                              logAnalyticData(META_ATTR,"Meta-atributo",YYText(),lineno(),currentColumn);
                              metaAttrCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              return META_ATTR;
                            }
{new_data_type}             {
                              logAnalyticData(NEW_DATA_TYPE,"Novo tipo de dado",YYText(),lineno(),currentColumn);
                              newDataTypeIdCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              currentLexeme = YYText();
                              return NEW_DATA_TYPE;
                            }
{class}                     {
                              logAnalyticData(CLASS_ID,"Identificador de classe",YYText(),lineno(),currentColumn);
                              classIdCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              currentLexeme = YYText();
                              return CLASS_ID;
                            }
{relation}              {
                              logAnalyticData(RELATION_ID,"Identificador de relação",YYText(),lineno(),currentColumn);
                              relationIdCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              currentLexeme = YYText();
                              return RELATION_ID;
                            }
{instance}                  {
                              logAnalyticData(INSTANCE_ID,"Identificador de instância",YYText(),lineno(),currentColumn);
                              instanceIdCount++;
                              lastTokenColumn = currentColumn;  
                              currentColumn += YYLeng();
                              currentLexeme = YYText();
                              return INSTANCE_ID;
                            }
.                           {
                              logLexicalError(YYText(), lineno(), currentColumn);
                              currentColumn += YYLeng();
                              return UNKNOWN;
                            }
%%

