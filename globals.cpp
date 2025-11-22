#include "globals.h"
#include <sstream>
#include <iostream>

// Variáveis globais
int currentColumn = 1;
int lastTokenColumn = 1;

std::ofstream outputAnalyticData;
std::ofstream outputSyntheticData;

unsigned long keywordCount = 0;
unsigned long nativeDataTypeCount = 0;
unsigned long metaAttrCount = 0;
unsigned long specialSymbolCount = 0;
unsigned long classEsterotypeCount = 0;
unsigned long relationEstereotypeCount = 0;
unsigned long classIdCount = 0;
unsigned long relationIdCount = 0;
unsigned long instanceIdCount = 0;
unsigned long newDataTypeIdCount = 0;
unsigned long numberCount = 0;

// Funções globais
void logAnalyticData(int token, const std::string& type,
                     const char* lexeme, int line, int column)
{
    if (outputAnalyticData.is_open()) {
        outputAnalyticData << "token: " << token
                           << " | lexeme: " << lexeme
                           << " | type: " << type
                           << " | line: " << line
                           << " | column: " << column << '\n';
    }
}

void logLexicalError(const char* lexeme, int line, int column)
{
    std::stringstream ss;
    ss << "ERRO LÉXICO: Lexema \"" << lexeme << "\" inválido. "
       << "(linha " << line << ", coluna " << column << ")\n";

    std::cerr << ss.str();

    if (outputAnalyticData.is_open()) {
        outputAnalyticData << ss.str();
    }
}

void flushSyntheticLog()
{
    if (!outputSyntheticData.is_open()) return;

    outputSyntheticData << "Palavras Reservadas: " << keywordCount << '\n'
                        << "Tipos de dados nativos: " << nativeDataTypeCount << '\n'
                        << "Meta-atributos: " << metaAttrCount << '\n'
                        << "Símbolos especiais: " << specialSymbolCount << '\n'
                        << "Estereótipos de classe: " << classEsterotypeCount << '\n'
                        << "Estereótipos de relação: " << relationEstereotypeCount << '\n'
                        << "Identificadores de classe: " << classIdCount << '\n'
                        << "Identificadores de relação: " << relationIdCount << '\n'
                        << "Identificadores de instância: " << instanceIdCount << '\n'
                        << "Identificadores de novo tipo de dado: " << newDataTypeIdCount << '\n'
                        << "Números: " << numberCount << '\n';
}
