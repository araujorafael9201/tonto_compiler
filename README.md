# Tonto Compiler - Lexical Analyzer

A lexical analyzer (scanner) for the **Tonto** language, developed as a college project for the Compilers course. This project currently implements the first phase of compilation: lexical analysis using **Flex** (Fast Lexical Analyzer).

## 👥 Authors

- [Rafael Araújo](https://github.com/araujorafael9201)
- [Lucas Alexandre](https://github.com/lucasalexandreao)

## 📋 Project Overview

**Tonto** is a domain-specific language designed for ontology modeling, supporting stereotypes from OntoUML and UFO (Unified Foundational Ontology). The lexical analyzer recognizes and categorizes tokens specific to ontological modeling, including:

- **Reserved Keywords**: `genset`, `disjoint`, `complete`, `general`, `specifics`, `where`, `package`, `import`, `functional-complexes`
- **Class Stereotypes**: `event`, `situation`, `kind`, `collective`, `quality`, `mode`, `subkind`, `phase`, `role`, `mixin`, etc.
- **Relationship Stereotypes**: `material`, `mediation`, `characterization`, `componentOf`, `instantiation`, `participation`, `composition`, etc.
- **Native Data Types**: `number`, `string`, `boolean`, `date`, `time`, `datetime`
- **Meta-Attributes**: `ordered`, `const`, `derived`, `subsets`, `redefines`
- **Special Symbols**: `{`, `}`, `(`, `)`, `[`, `]`, `..`, `<>--`, `--<>`, `*`, `@`, `:`
- **Identifiers**: Classes, relations, instances, and custom data types

## 🚀 Current Status

✅ **Completed**: Lexical Analysis  
⏳ **In Progress**: Syntactic Analysis (Parser)  
🔜 **Future**: Semantic Analysis, Intermediate Code Generation

## 🛠️ Technologies Used

- **Flex (Lex)**: Lexical analyzer generator
- **C++17**: Implementation language
- **CMake**: Build system
- **GCC/Clang**: C++ compiler

## 📂 Project Structure

```
tonto_compiler/
├── lexer.l              # Flex lexical specification
├── tokens.h             # Token definitions and constants
├── CMakeLists.txt       # CMake build configuration
├── Build/               # Build directory (generated)
└── README.md            # This file
```

## 🔧 Building the Project

### Prerequisites

- CMake 3.0 or higher
- Flex (Fast Lexical Analyzer)
- C++17 compatible compiler (GCC, Clang, or MSVC)

### Linux/macOS

Install dependencies:
```bash
# Ubuntu/Debian/Mint
sudo apt-get install flex libfl-dev cmake build-essential

# Fedora/RHEL
sudo dnf install flex cmake gcc-c++

# macOS
brew install flex cmake
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

After building and add a `.tonto` file on project root, run the analyzer:

```bash
# From the Build directory
./tonto ../Car.tonto

# Or from project root
./Build/tonto Car.tonto
```

### Example Output

The analyzer generates two output files on Build directory:
- **analyticData.log**: Detailed token-by-token analysis
- **syntheticData.log**: Summary statistics

```
# analyticData.log

PALAVRA RESERVADA | package | line: 1 | column: 1
CLASSE | CarOwnership | line: 1 | column: 9
PALAVRA RESERVADA | kind | line: 3 | column: 1
CLASSE | Organization | line: 3 | column: 6

...

# syntheticData.log

9 Palavras reservadas encontradas
3 Tipos de dados nativos encontrados
2 Meta-Atributos encontrados
5 Estereótipos de classe encontrados
1 Estereótipos de relação encontrados
15 Símbolos especiais encontrados
```

### ⚠️ Error Handling

When lexical errors are detected (for example, invalid symbols or malformed tokens), the analyzer reports them in two ways:

* **Terminal Output**: An error message is immediately printed to the console, indicating the line and column where the error occurred.
* **`analyticData.log` File**: The same error message is also recorded in the analytical log file for later review.

Example:

```
ERRO LÉXICO: Lexema "," inválido. | line: 1 | column: 5
```

## 📝 Token Categories

### 1. Reserved Keywords (9 tokens)
Control structures and declarations: `genset`, `disjoint`, `complete`, `general`, `specifics`, `where`, `package`, `import`, `functional-complexes`

### 2. Class Stereotypes (19 tokens)
OntoUML/UFO entity types: `kind`, `subkind`, `phase`, `role`, `mixin`, `collective`, `quantity`, `quality`, `mode`, `event`, `situation`, etc.

### 3. Relationship Stereotypes (24 tokens)
OntoUML/UFO relation types: `material`, `mediation`, `characterization`, `componentOf`, `memberOf`, `composition`, `aggregation`, `instantiation`, etc.

### 4. Native Data Types (6 tokens)
Built-in types: `number`, `string`, `boolean`, `date`, `time`, `datetime`

### 5. Meta-Attributes (5 tokens)
Property modifiers: `ordered`, `const`, `derived`, `subsets`, `redefines`

### 6. Identifiers
- **Classes**: Start with uppercase letter (e.g., `Organization`, `Car_Agency`)
- **Relationships**: Start with lowercase letter (e.g., `involvesOwner`)
- **Instances**: Alphanumeric ending with digits (e.g., `p_3`, `car123`)
- **Custom Data Types**: Match pattern `*DataType` (e.g., `PersonDataType`)

### 7. Special Symbols (11 tokens)
`{`, `}`, `(`, `)`, `[`, `]`, `..`, `<>--`, `--<>`, `*`, `@`, `:`

### 8. Numeric Constants
Integer and floating-point numbers (e.g., `42`, `3.14`)

## 🐛 Known Limitations

- Currently only performs lexical analysis (tokenization)
- No syntax validation (parser not yet implemented)
- No semantic analysis or type checking

## 📚 References

- **Tonto Language**: [https://github.com/matheuslenke/Tonto](https://github.com/matheuslenke/Tonto)
- **Flex Manual**: [https://github.com/westes/flex](https://github.com/westes/flex)