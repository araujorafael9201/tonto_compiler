# Tonto Compiler 

A compiler for the **Tonto** language, developed as a college project for the Compilers course. This project currently implements lexical analysis using **Flex** (Fast Lexical Analyzer), syntactic analysis using **Bison** and semantic analysis.

## 👥 Authors

- [Rafael Araújo](https://github.com/araujorafael9201)
- [Lucas Alexandre](https://github.com/lucasalexandreao)

## 📋 Project Overview

**Tonto** is a domain-specific language designed for ontology modeling, supporting stereotypes from OntoUML and UFO (Unified Foundational Ontology).

The **LEXICAL ANALYZER** recognizes and categorizes tokens specific to ontological modeling, including:

- **Reserved Keywords**: `genset`, `disjoint`, `complete`, `general`, `specifics`, `where`, `package`, `import`, `functional-complexes`, `specializes`, `enum`, `relation`, `datatype`
- **Class Stereotypes**: `event`, `situation`, `kind`, `collective`, `quality`, `mode`, `subkind`, `phase`, `role`, `mixin`, etc.
- **Relationship Stereotypes**: `material`, `mediation`, `characterization`, `componentOf`, `instantiation`, `participation`, `composition`, etc.
- **Native Data Types**: `number`, `string`, `boolean`, `date`, `time`, `datetime`
- **Meta-Attributes**: `ordered`, `const`, `derived`, `subsets`, `redefines`
- **Special Symbols**: `{`, `}`, `(`, `)`, `[`, `]`, `..`, `<>--`, `--<>`, `*`, `@`, `:`, `,` 
- **Identifiers**: Classes, relations, instances, attributes (same rule for identifying relationships) and custom data types



The **SYNCTATIC ANALYZER** recognizes the following patterns:

- **Package Declarations**
```
package MyPackage

```
- **Class Declarations**
```
kind Person {
  name: string
  birthDate: date {const}
  age: number
}

# or, inline:
phase Child specializes Dog

```
- **New Datatype Declarations**
```
datatype AddressDataType {
  street: string
  num: number
}
```
- **Enum Declarations**
```
enum EyeColor {blue1, green2, brown3}
```
- **Genset Declarations**
```
disjoint complete genset PersonAgeGroup where Child, Adult specializes Person 

# or, in block:
genset PersonAgeGroup {
  general Person 
  specifics Child, Adult
}
```
- **Relation Declarations**
```
# internal relation
kind University {
  @componentOf[1] <>-- [1..*] Department
}

# external relation
@mediation relation EmploymentContract [1..*] -- [1] Employee
```



The **SEMANTIC ANALYZER** implements validation of the following design patterns:

- **Subkind Pattern**
```
package Subkind_Pattern

kind ClassName
subkind SubclassName1 specializes ClassName
subkinf SubclassName2 specializes ClassName

disjoint complete genset kind_Subkind_Genset_Name {
    general ClassName
    specifics SubclassName1, SubclassName2
}
```
- **Role Pattern**
```
package Role_Pattern

kind ClassName
role Role_Name1 specializes ClassName
role Role_Name2 specializes ClassName

complete genset Class_Role_Genset_Name {
    general ClassName
    specifics Role_Name1, Role_Name2
}
```
- **Phase Pattern**
```
package Phase_Pattern

kind ClassName
phase Phase_Name1 specializes ClassName
phase Phase_Name2 specializes ClassName
phase Phase_NameN specializes ClassName

disjoint complete genset Class_Phase_Genset_Name {
    general ClassName
    specifics Phase_Name1, Phase_Name2, Phase_NameN
}
```
- **Relator Pattern**
```
package Relator_Pattern

kind ClassName1
kind ClassName2

role Role_Name1 specializes ClassName1
role Role_Name2 specializes ClassName2

relator Relator_Name {
    @mediation [1..*] -- [1..*] Role_Name1
    @mediation [1..*] -- [1..*] Role_Name2
}

@material relation Role_Name1 [1..*] -- relationName -- [1..*] Role_Name2
```
- **Mode Pattern**
```
package Mode_Pattern

kind ClassName1
kind ClassName2

mode Mode_Name1 {
    @characterization [1..*] -- [1] ClassName1
    @externalDependence [1..*] -- [1..*] ClassName2
}


```
- **RoleMixin Pattern**
```
package RoleMixin_Pattern

kind ClassName1
kind ClassName2

roleMixin RoleMixin_Name

role Role_Name1 specializes ClassName1, RoleMixin_Name
role Role_Name2 specializes ClassName2, RoleMixin_Name

disjoint complete genset RoleMixin_Genset_Name {
    general RoleMixin_Name
    specifics Role_Name1, Role_Name2
}
```

## 🚀 Current Status

✅ **Completed**: Lexical Analysis  
✅ **Completed**: Syntactic Analysis (Parser)  
✅ **Completed**: Semantic Analysis

## 🛠️ Technologies Used

- **Flex (Lex)**: Lexical analyzer generator
- **Bison**: Syntactic analyzer generator
- **C++17**: Implementation language
- **CMake**: Build system
- **GCC/Clang**: C++ compiler

## 📂 Project Structure

```
tonto_compiler/
├── lexer.l              # Flex lexical specification
├── parser.y             # Bison syntactic specification and main (input reading)
├── globals.h            # Definitions of variables and global methods
├── globals.cpp          # Implementation of variables and global methods
├── CMakeLists.txt       # CMake build configuration
├── Build/               # Build directory (generated)
└── README.md            # This file
```

## 🔧 Building the Project

### Prerequisites

- CMake 3.0 or higher
- Flex (Fast Lexical Analyzer)
- Bison
- C++17 compatible compiler (GCC, Clang, or MSVC)

### Linux/macOS

Install dependencies:
```bash
# Ubuntu/Debian/Mint
sudo apt-get install flex bison libfl-dev libbsion-dev cmake build-essential

# Fedora/RHEL
sudo dnf install flex bison cmake gcc-c++

# macOS
brew install flex bison cmake

```

Clone the repository:
```bash
# Using HTTPS
git clone https://github.com/araujorafael9201/tonto_compiler.git

# Or using SSH
git clone git@github.com:araujorafael9201/tonto_compiler.git

# Navigate to directory
cd tonto_compiler
```

Build the project:
```bash
# Create and navigate to build directory
mkdir -p Build
cd Build

# Configure with CMake
cmake -DCMAKE_BUILD_TYPE=Build ..

# Build
make
```

## ▶️ Running the Program

After building and add one or more `.tonto` file on project root, run the analyzer:

```bash
# From the Build directory
./tonto ../Car.tonto ../Person.tonto

# Or from project root
./Build/tonto Car.tonto Person.tonto
```

### Example Output

The program generates two output files in the Build directory, one for each input file:

`(* is the name of the input file.)`
- *_analytic.log: Detailed token-by-token analysis
- *_synthetic.log: Summary statistics about lexical, syntactic and semantic analysis


```
# *_analytic.log

token: 269 | lexeme: import | type: Palavra Reservada | line: 1 | column: 1
token: 274 | lexeme: Pessoa | type: Identificador de classe | line: 1 | column: 8
token: 269 | lexeme: import | type: Palavra Reservada | line: 2 | column: 1
token: 274 | lexeme: Empresa | type: Identificador de classe | line: 2 | column: 8
token: 259 | lexeme: package | type: Palavra Reservada | line: 4 | column: 1
.
.
.

# *_synthetic.log

=== RELATÓRIO SINTÁTICO ===

1. PACOTES (1):
   - Cliente

2. CLASSES (3):
   - Cliente
   - ClienteIndividual
   - ClienteEmpresarial

3. NOVOS TIPOS DE DADOS (0):

4. ENUMS (0):

5. GENERALIZAÇÕES (1):
   - Genset: Tipos_de_Clientes | Mãe: Cliente | Filhas: ClienteIndividual, ClienteEmpresarial | Tipo: Bloco | Disjoint: Sim | Complete: Sim

6. RELAÇÕES (0):

=== ESTATÍSTICAS LÉXICAS ===
Palavras Reservadas: 10
Tipos de dados nativos: 0
Meta-atributos: 0
Símbolos especiais: 5
Estereótipos de classe: 3
Estereótipos de relação: 0
Identificadores de classe: 14
Identificadores de relação: 0
Identificadores de instância: 0
Identificadores de novo tipo de dado: 0
Números: 0

=== RELATÓRIO DE ANÁLISE SEMÂNTICA ===

>> Verificando Padrões de Generalização (Subkind, Role, Phase, RoleMixin)...
   ---------------------------------------------------
   Genset: 'Tipos_de_Clientes'
   Estrutura: ClienteIndividual (role) -> Cliente (roleMixin)
   [RESULTADO] Generalização VÁLIDA.
   ---------------------------------------------------
   Genset: 'Tipos_de_Clientes'
   Estrutura: ClienteEmpresarial (role) -> Cliente (roleMixin)
   [RESULTADO] Generalização VÁLIDA.

>> Verificando Padrão Relator...
   [INFO] Nenhum Relator encontrado na ontologia.

>> Verificando Padrão Mode...
   ------------------------------------------------------
   [INFO] Nenhuma classe com estereótipo 'mode' foi declarada ou encontrada.
   ------------------------------------------------------

======================================================



```

### ⚠️ Error Handling

When errors are detected, the program reports them in two ways:

* **Terminal Output**: An error message is immediately printed to the console, indicating the line and column where the error occurred.
* **`analytic.log` File**: The error messages for **lexical errors** are also recorded in the analytical log file for later review.



Example:

```
Processing: ../teste.tonto
syntax error, unexpected [ ("[" at line 3, column 1)
lexical error: invalid token "-" (line 4, column 6)
syntax error, unexpected invalid token, expecting : ("-" at line 4, column 2)
syntax error, unexpected relation name ("age" at line 6, column 3)
Logs: ../teste_analytic.log, ../teste_synthetic.log
```
Furthermore, errors are corrected through **coercion**.




## 📚 References

- **Tonto Language**: [https://github.com/matheuslenke/Tonto](https://github.com/matheuslenke/Tonto)
- **Flex Manual**: [https://github.com/westes/flex](https://github.com/westes/flex)
- **Bison Manual**: [https://github.com/akimd/bison](https://github.com/akimd/bison)