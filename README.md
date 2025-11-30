# Tonto Compiler 

A compiler for the **Tonto** language, developed as a college project for the Compilers course. This project currently implements lexical analysis using **Flex** (Fast Lexical Analyzer) and syntactic anaysis using **Bison**.

## 👥 Authors

- [Rafael Araújo](https://github.com/araujorafael9201)
- [Lucas Alexandre](https://github.com/lucasalexandreao)

## 📋 Project Overview

**Tonto** is a domain-specific language designed for ontology modeling, supporting stereotypes from OntoUML and UFO (Unified Foundational Ontology).

The **lexical analyzer** recognizes and categorizes tokens specific to ontological modeling, including:

- **Reserved Keywords**: `genset`, `disjoint`, `complete`, `general`, `specifics`, `where`, `package`, `import`, `functional-complexes`, `specializes`, `enum`, `relation`, `datatype`
- **Class Stereotypes**: `event`, `situation`, `kind`, `collective`, `quality`, `mode`, `subkind`, `phase`, `role`, `mixin`, etc.
- **Relationship Stereotypes**: `material`, `mediation`, `characterization`, `componentOf`, `instantiation`, `participation`, `composition`, etc.
- **Native Data Types**: `number`, `string`, `boolean`, `date`, `time`, `datetime`
- **Meta-Attributes**: `ordered`, `const`, `derived`, `subsets`, `redefines`
- **Special Symbols**: `{`, `}`, `(`, `)`, `[`, `]`, `..`, `<>--`, `--<>`, `*`, `@`, `:`, `,` 
- **Identifiers**: Classes, relations, instances, attributes (same rule for identifying relationships) and custom data types

The **syntactic analyzer** recognizes the following patterns:

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


## 🚀 Current Status

✅ **Completed**: Lexical Analysis  
✅ **Completed**: Syntactic Analysis (Parser)  
🔜 **Future**: Semantic Analysis

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
├── parser.y             # Bison syntactic specification
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

## ▶️ Running the Lexical Analyzer

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
- *_synthetic.log: Summary statistics about lexical and syntactic analysis


```
# *_analytic.log

token: 259 | lexeme: package | type: Palavra Reservada | line: 1 | column: 1
token: 274 | lexeme: MyPackage | type: Identificador de classe | line: 1 | column: 9
token: 277 | lexeme: kind | type: Estereótipo de classe | line: 3 | column: 1
token: 274 | lexeme: Person | type: Identificador de classe | line: 3 | column: 6
token: 282 | lexeme: { | type: Símbolo Especial | line: 3 | column: 13
.
.
.

# *_synthetic.log

=== RELATÓRIO SINTÁTICO ===

1. PACOTES (1):
   - MyPackage

2. CLASSES (3):
   - Person
   - Child
   - University

3. NOVOS TIPOS DE DADOS (1):
   - AddressDataType

4. ENUMS (1):
   - EyeColor

5. GENERALIZAÇÕES (2):
   - Genset: PersonAgeGroup | Mãe: Person | Filhas: Child, Adult | Tipo: Inline
   - Genset: PersonAgeGroup | Mãe: Person | Filhas: Child, Adult | Tipo: Bloco

6. RELAÇÕES (1):
   - Estereótipo: mediation | Origem: EmploymentContract | Destino: Employee | Tipo: Externa

=== ESTATÍSTICAS LÉXICAS ===
Palavras Reservadas: 13
Tipos de dados nativos: 5
Meta-atributos: 1
Símbolos especiais: 36
Estereótipos de classe: 3
Estereótipos de relação: 2
Identificadores de classe: 17
Identificadores de relação: 5
Identificadores de instância: 3
Identificadores de novo tipo de dado: 1
Números: 4

```

### ⚠️ Error Handling

When errors are detected, the program reports them in two ways:

* **Terminal Output**: An error message is immediately printed to the console, indicating the line and column where the error (lexical or syntactic) occurred.
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



## 🐛 Known Limitations

- Currently only performs lexical analysis (tokenization) and syntax validation
- No semantic analysis

## 📚 References

- **Tonto Language**: [https://github.com/matheuslenke/Tonto](https://github.com/matheuslenke/Tonto)
- **Flex Manual**: [https://github.com/westes/flex](https://github.com/westes/flex)
- **Bison Manual**: [https://github.com/akimd/bison](https://github.com/akimd/bison)