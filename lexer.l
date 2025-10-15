%{
#include <iostream>
#include <fstream>

using namespace std;
%}

%option noyywrap

%%
.|\n	ECHO;
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
	fin.close();
}