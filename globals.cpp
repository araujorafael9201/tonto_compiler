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

Stereotype getStereotypeEnum(const std::string& s) {
    if (s == "kind") return Stereotype::Kind;
    if (s == "subkind") return Stereotype::Subkind;
    if (s == "phase") return Stereotype::Phase;
    if (s == "role") return Stereotype::Role;
    if (s == "category") return Stereotype::Category;
    if (s == "roleMixin") return Stereotype::RoleMixin;
    if (s == "mixin") return Stereotype::Mixin;
    return Stereotype::Other;
}

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
    
    // -- Validação de Padrões Baseados em Generalização --
    outputSyntheticData << "\n>> Verificando Padrões de Generalização (Subkind, Role, Phase, RoleMixin)...\n";
    
    if (generalizationsList.empty()) {
        outputSyntheticData << "   [INFO] Nenhuma generalização encontrada para análise.\n";
    }

    for (auto& gen : generalizationsList) {
        if (gen.specificClasses.empty()) continue;

        std::string generalStereotype = classStereotypes[gen.generalClass];
        
        for (const auto& specificClass : gen.specificClasses) {
            std::string specificStereotype = classStereotypes[specificClass];

            outputSyntheticData << "   ---------------------------------------------------\n";
            outputSyntheticData << "   Genset: '" << gen.name << "'\n";
            outputSyntheticData << "   Estrutura: " << specificClass << " (" << specificStereotype << ") -> " 
                      << gen.generalClass << " (" << generalStereotype << ")\n";

            bool valid = true;
            std::string errorMsg = "";

            Stereotype genType = getStereotypeEnum(generalStereotype);
            Stereotype specType = getStereotypeEnum(specificStereotype);

            // Definição de grupos para verificação
            bool parentAntiRigid = (genType == Stereotype::Role || genType == Stereotype::Phase || genType == Stereotype::RoleMixin);
            bool childRigid = (specType == Stereotype::Kind || specType == Stereotype::Subkind || specType == Stereotype::Category);

            // 1. Regra da Rigidez
            if (parentAntiRigid && childRigid) {
                valid = false;
                errorMsg = "Regra da Rigidez violada: Tipo Antirrígido (" + generalStereotype + ") não pode generalizar Tipo Rígido (" + specificStereotype + ").";
            }
            else {
                // 2. Validação por Tabela de Compatibilidade
                switch (genType) {
                    case Stereotype::Kind:
                        if (specType != Stereotype::Subkind && specType != Stereotype::Phase && specType != Stereotype::Role) {
                            valid = false;
                            errorMsg = "Kind só pode ser especializado por Subkind, Phase ou Role.";
                        }
                        break;
                    case Stereotype::Subkind:
                        if (specType != Stereotype::Subkind && specType != Stereotype::Phase && specType != Stereotype::Role) {
                            valid = false;
                            errorMsg = "Subkind só pode ser especializado por Subkind, Phase ou Role.";
                        }
                        break;
                    case Stereotype::Phase:
                        if (specType != Stereotype::Phase && specType != Stereotype::Role) {
                            valid = false;
                            errorMsg = "Phase só pode ser especializada por Phase ou Role.";
                        }
                        break;
                    case Stereotype::Role:
                        if (specType != Stereotype::Role) {
                            valid = false;
                            errorMsg = "Role só pode ser especializado por Role.";
                        }
                        break;
                    case Stereotype::Category:
                        if (specType != Stereotype::Kind && specType != Stereotype::Subkind && specType != Stereotype::Category) {
                            valid = false;
                            errorMsg = "Category só pode ser especializada por Kind, Subkind ou Category.";
                        }
                        break;
                    case Stereotype::RoleMixin:
                        if (specType != Stereotype::Role && specType != Stereotype::RoleMixin) {
                            valid = false;
                            errorMsg = "RoleMixin só pode ser especializado por Role ou RoleMixin.";
                        }
                        break;
                    case Stereotype::Mixin:
                        // Mixin pode ser especializado por Mixin, Category, RoleMixin e Sortais (Kind, Subkind, Phase, Role)
                        if (specType != Stereotype::Mixin && specType != Stereotype::Category && specType != Stereotype::RoleMixin &&
                            specType != Stereotype::Kind && specType != Stereotype::Subkind && specType != Stereotype::Phase && specType != Stereotype::Role) {
                            valid = false;
                            errorMsg = "Mixin só pode ser especializado por outros Mixins ou Sortais.";
                        }
                        break;
                    default:
                        // Outros casos ou desconhecidos não são validados estritamente aqui
                        break;
                }
            }

            if (valid) {
                outputSyntheticData << "   [RESULTADO] Generalização VÁLIDA.\n";
            } else {
                outputSyntheticData << "   [ERRO] " << errorMsg << "\n";
            }
        }
    }

    // -- Validação de Padrões Baseados em Relação --
    
    // 4. Padrão Relator
    outputSyntheticData << "\n>> Verificando Padrão Relator...\n";
    bool relatorFound = false;
    for (auto const& [className, stereotype] : classStereotypes) {
        if (stereotype == "relator") {
            relatorFound = true;
            outputSyntheticData << "   ---------------------------------------------------\n";
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

            outputSyntheticData << "   Mediações detectadas: " << mediationCount << "\n";

            if (mediationCount >= 2) {
                // Verifica relação material derivada
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
                    outputSyntheticData << "   [RESULTADO] Padrão Relator COMPLETO (com Material derivada).\n";
                } else {
                    outputSyntheticData << "   [AVISO] Padrão Relator PARCIAL: Relação 'material' explícita não encontrada entre os papeis.\n";
                }

            } else {
                outputSyntheticData << "   [ERRO] Relator deve mediar pelo menos 2 entidades (encontradas: " << mediationCount << ").\n";
            }
        }
    }
    if (!relatorFound) outputSyntheticData << "   [INFO] Nenhum Relator encontrado na ontologia.\n";


    // 5. Padrão Mode
    outputSyntheticData << "\n>> Verificando Padrão Mode...\n";
    bool modeFound = false;
    
    for (auto const& [className, stereotype] : classStereotypes) {
        if (stereotype == "mode") {
            modeFound = true;
            outputSyntheticData << "   ------------------------------------------------------\n";
            outputSyntheticData << "   [ANÁLISE] Classe: " << className << " | Estereótipo: mode\n";
            
            bool hasCharacterization = false;
            bool hasExternalDep = false;

            // Verifica relações conectadas à classe Mode
            for (const auto& rel : relationsList) {
                if (rel.sourceClass == className || rel.targetClass == className) {
                    if (rel.stereotype == "characterization") hasCharacterization = true;
                    if (rel.stereotype == "externalDependence") hasExternalDep = true;
                }
            }

            // Relatório Explícito de Ausência/Presença
            outputSyntheticData << "   [VERIFICAÇÃO DE DEPENDÊNCIAS]\n";
            outputSyntheticData << "      1. Relação 'characterization':   " 
                      << (hasCharacterization ? "[OK] Presente" : "[FALHA] AUSENTE") << "\n";
            
            outputSyntheticData << "      2. Relação 'externalDependence': " 
                      << (hasExternalDep ? "[OK] Presente" : "[FALHA] AUSENTE") << "\n";

            if (hasCharacterization && hasExternalDep) {
                outputSyntheticData << "   [RESULTADO FINAL] Padrão Mode VÁLIDO para '" << className << "'.\n";
            } else {
                outputSyntheticData << "   [RESULTADO FINAL] Padrão Mode INVÁLIDO para '" << className << "'.\n";
            }
        }
    }
    
    if (!modeFound) {
        outputSyntheticData << "   ------------------------------------------------------\n";
        outputSyntheticData << "   [INFO] Nenhuma classe com estereótipo 'mode' foi declarada ou encontrada.\n";
        outputSyntheticData << "   ------------------------------------------------------\n";
    }

    outputSyntheticData << "\n======================================================\n\n";
}