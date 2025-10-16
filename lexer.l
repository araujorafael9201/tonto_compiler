%{
#include <iostream>
#include <fstream>
#include "tokens.h"

using namespace std;

int classCount = 0;
%}

%option noyywrap
%option yylineno

%%
event|situation|pry|mixin|phaseMixin|roleMixin|historicalRoleMixin|kind|collective|quantity|quality|mode|intrisicMode|extrinsicMode|subkind|phase|role|historicalRole {
	cout << YYText() << " on line " << lineno() << endl;
	classCount++;
};
.|\n	;
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
	cout << classCount << " Estereótipos de classe encontrados" << endl;
	fin.close();
}