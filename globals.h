#pragma once
#include <fstream>
#include <string>
#include <vector>


extern std::string currentLexeme; // Usada para passar o texto do Lexer para o Parser de forma simples
extern std::string currentParsingClass; // Usada para saber a classe atual do bloco que está sendo analisado (para relações internas)

// Armazenamento de Dados Sintáticos 
struct Generalization {
    std::string name;
    std::string generalClass;
    std::vector<std::string> specificClasses;
    bool isInline;
};

struct Relation {
    std::string stereotype;
    std::string sourceClass;
    std::string targetClass;
    bool isExternal;
};

extern std::vector<std::string> packageNames;
extern std::vector<std::string> classNames;
extern std::vector<std::string> newDataTypeNames;
extern std::vector<std::string> enumNames;
extern std::vector<Generalization> generalizationsList;
extern std::vector<Relation> relationsList;

// Variáveis globais
extern int currentColumn;     // coluna atual enquanto lê o arquivo
extern int lastTokenColumn;   // coluna onde o último token começou

// Arquivos de log
extern std::ofstream outputAnalyticData;
extern std::ofstream outputSyntheticData;

// Contadores
extern unsigned long keywordCount;
extern unsigned long nativeDataTypeCount;
extern unsigned long metaAttrCount;
extern unsigned long specialSymbolCount;
extern unsigned long classEsterotypeCount;
extern unsigned long relationEstereotypeCount;
extern unsigned long classIdCount;
extern unsigned long relationIdCount;
extern unsigned long instanceIdCount;
extern unsigned long newDataTypeIdCount;
extern unsigned long numberCount;

void resetGlobals();

// Funções globais
void logAnalyticData(int token, const std::string& type, const char* lexeme, int line, int column);
void logLexicalError(const char* lexeme, int line, int column);

void flushSyntacticLog();
