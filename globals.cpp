#include "globals.h"
#include <sstream>
#include <iostream>
#include <algorithm> // Para std::find

std::string currentLexeme = "";
std::string currentParsingClass = "";

std::vector<std::string> packageNames;
std::vector<std::string> classNames;
std::vector<std::string> newDataTypeNames;
std::vector<std::string> enumNames;
std::vector<Generalization> generalizationsList;
std::vector<Relation> relationsList;
std::map<std::string, std::string> classStereotypes;

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
    ss << "lexical error: invalid token \"" << lexeme << "\" "
       << "(line " << line << ", column " << column << ")\n";

    std::cerr << ss.str();

    if (outputAnalyticData.is_open()) {
        outputAnalyticData << ss.str();
    }
}

void resetGlobals() {
    currentLexeme = "";
    currentParsingClass = "";

    packageNames.clear();
    classNames.clear();
    newDataTypeNames.clear();
    enumNames.clear();
    generalizationsList.clear();
    relationsList.clear();
    classStereotypes.clear();

    currentColumn = 1;
    lastTokenColumn = 1;

    keywordCount = 0;
    nativeDataTypeCount = 0;
    metaAttrCount = 0;
    specialSymbolCount = 0;
    classEsterotypeCount = 0;
    relationEstereotypeCount = 0;
    classIdCount = 0;
    relationIdCount = 0;
    instanceIdCount = 0;
    newDataTypeIdCount = 0;
    numberCount = 0;
}

void flushSyntacticLog()
{
    if (!outputSyntheticData.is_open()) return;

    outputSyntheticData << "=== RELATÓRIO SINTÁTICO ===\n\n";

    outputSyntheticData << "1. PACOTES (" << packageNames.size() << "):\n";
    for (const auto& name : packageNames) outputSyntheticData << "   - " << name << "\n";

    outputSyntheticData << "\n2. CLASSES (" << classNames.size() << "):\n";
    for (const auto& name : classNames) outputSyntheticData << "   - " << name << "\n";

    outputSyntheticData << "\n3. NOVOS TIPOS DE DADOS (" << newDataTypeNames.size() << "):\n";
    for (const auto& name : newDataTypeNames) outputSyntheticData << "   - " << name << "\n";

    outputSyntheticData << "\n4. ENUMS (" << enumNames.size() << "):\n";
    for (const auto& name : enumNames) outputSyntheticData << "   - " << name << "\n";

    outputSyntheticData << "\n5. GENERALIZAÇÕES (" << generalizationsList.size() << "):\n";
    for (const auto& gen : generalizationsList) {
        outputSyntheticData << "   - Genset: " << gen.name << " | Mãe: " << gen.generalClass << " | Filhas: ";
        for (size_t i = 0; i < gen.specificClasses.size(); i++) {
            outputSyntheticData << gen.specificClasses[i] << (i < gen.specificClasses.size() - 1 ? ", " : "");
        }
        outputSyntheticData << " | Tipo: " << (gen.isInline ? "Inline" : "Bloco")
                            << " | Disjoint: " << (gen.isDisjoint ? "Sim" : "Não")
                            << " | Complete: " << (gen.isComplete ? "Sim" : "Não") << "\n";
    }

    outputSyntheticData << "\n6. RELAÇÕES (" << relationsList.size() << "):\n";
    for (const auto& rel : relationsList) {
        outputSyntheticData << "   - Estereótipo: " << rel.stereotype 
                            << " | Origem: " << rel.sourceClass 
                            << " | Destino: " << rel.targetClass
                            << " | Tipo: " << (rel.isExternal ? "Externa" : "Interna") << "\n";
    }
    
    outputSyntheticData << "\n=== ESTATÍSTICAS LÉXICAS ===\n";
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

void performSemanticAnalysis() {
    if (!outputSyntheticData.is_open()) return;

    outputSyntheticData << "\n=== RELATÓRIO DE ANÁLISE SEMÂNTICA ===\n";
    
    // 1. Validar Padrões de Generalização (Subkind, Role, Phase)
    for (auto& gen : generalizationsList) {
        if (gen.specificClasses.empty()) continue;

        // Recupera os estereótipos da mãe e da primeira filha (assume homogeneidade no genset)
        std::string generalStereotype = classStereotypes[gen.generalClass];
        std::string firstSpecific = gen.specificClasses[0];
        std::string specificStereotype = classStereotypes[firstSpecific];

        outputSyntheticData << ">> Analisando Genset '" << gen.name << "' (" << specificStereotype << " -> " << generalStereotype << ")...\n";

        // --- Padrão Subkind ---
        if (specificStereotype == "subkind") {
            if (generalStereotype == "kind") {
                outputSyntheticData << "   [OK] Padrão Subkind identificado corretamente.\n";
            } else {
                outputSyntheticData << "   [ERRO] Subkind deve especializar Kind. (Encontrado: " << generalStereotype << ")\n";
            }
        }
        // --- Padrão Role ---
        else if (specificStereotype == "role") {
            // Regra comum: Role não deve ser rígido como disjoint (contextual, mas vamos assumir a regra do trabalho)
            if (gen.isDisjoint) {
                outputSyntheticData << "   [ERRO SEMÂNTICO] Padrão Role: Genset não deve ser 'disjoint'.\n";
                // Coerção
                gen.isDisjoint = false; 
                outputSyntheticData << "   [CORREÇÃO/COERÇÃO] Propriedade 'disjoint' removida do Genset.\n";
            } else {
                 outputSyntheticData << "   [OK] Padrão Role validado.\n";
            }
        }
        // --- Padrão Phase ---
        else if (specificStereotype == "phase") {
             // Regra: "disjoint is mandatory for phases"
             if (!gen.isDisjoint) {
                 outputSyntheticData << "   [ERRO SEMÂNTICO] Padrão Phase: Genset deve ser obrigatoriamente 'disjoint'.\n";
                 // Coerção
                 gen.isDisjoint = true;
                 outputSyntheticData << "   [CORREÇÃO/COERÇÃO] Propriedade 'disjoint' adicionada ao Genset.\n";
             } else {
                 outputSyntheticData << "   [OK] Padrão Phase validado (é disjoint).\n";
             }
        }
    }

    // 2. Validar Padrão Relator
    outputSyntheticData << "\n>> Verificando Padrão Relator...\n";
    bool relatorFound = false;
    for (auto const& [className, stereotype] : classStereotypes) {
        if (stereotype == "relator") {
            relatorFound = true;
            outputSyntheticData << "   Relator encontrado: " << className << "\n";
            
            // Conta mediações conectadas a este relator
            int mediationCount = 0;
            std::vector<std::string> mediatedClasses;
            
            for (const auto& rel : relationsList) {
                if (rel.stereotype == "mediation") {
                    if (rel.sourceClass == className) {
                        mediationCount++;
                        mediatedClasses.push_back(rel.targetClass);
                    } else if (rel.targetClass == className) {
                        mediationCount++;
                        mediatedClasses.push_back(rel.sourceClass);
                    }
                }
            }

            if (mediationCount >= 2) {
                outputSyntheticData << "   [OK] Possui " << mediationCount << " mediações.\n";
                // Tenta encontrar relação material entre os mediados (opcional mas recomendado no padrão)
                bool materialFound = false;
                for (const auto& rel : relationsList) {
                     if (rel.stereotype == "material") {
                         bool srcIn = std::find(mediatedClasses.begin(), mediatedClasses.end(), rel.sourceClass) != mediatedClasses.end();
                         bool tgtIn = std::find(mediatedClasses.begin(), mediatedClasses.end(), rel.targetClass) != mediatedClasses.end();
                         if (srcIn && tgtIn) {
                             materialFound = true;
                             break;
                         }
                     }
                }
                
                if (materialFound) {
                    outputSyntheticData << "   [OK] Relação Material derivada encontrada entre os mediados.\n";
                } else {
                    outputSyntheticData << "   [AVISO] Padrão Relator incompleto: Relação 'material' explícita entre os papeis não encontrada.\n";
                }
            } else {
                outputSyntheticData << "   [ERRO] Relator deve mediar pelo menos 2 entidades (encontradas: " << mediationCount << ").\n";
            }
        }
    }
    if (!relatorFound) outputSyntheticData << "   Nenhum Relator encontrado.\n";

    // 3. Validar Padrão Mode
    outputSyntheticData << "\n>> Verificando Padrão Mode...\n";
    bool modeFound = false;
    for (auto const& [className, stereotype] : classStereotypes) {
        if (stereotype == "mode") {
            modeFound = true;
            outputSyntheticData << "   Mode encontrado: " << className << "\n";
            bool hasCharacterization = false;
            bool hasExternalDep = false;

            for (const auto& rel : relationsList) {
                // Mode normalmente é a origem da characterization (caracteriza algo) ou destino (algo tem um modo)
                if (rel.sourceClass == className || rel.targetClass == className) {
                    if (rel.stereotype == "characterization") hasCharacterization = true;
                    // Mode depende externamente de outra coisa (geralmente o portador ou outro)
                    if (rel.stereotype == "externalDependence") hasExternalDep = true;
                }
            }

            if (hasCharacterization && hasExternalDep) {
                outputSyntheticData << "   [OK] Padrão Mode completo (Characterization + ExternalDependence).\n";
            } else {
                if (!hasCharacterization) outputSyntheticData << "   [ERRO] Falta relação de 'characterization'.\n";
                if (!hasExternalDep) outputSyntheticData << "   [ERRO] Falta relação de 'externalDependence'.\n";
            }
        }
    }
    if (!modeFound) outputSyntheticData << "   Nenhum Mode encontrado.\n";

    outputSyntheticData << "========================================\n\n";
}