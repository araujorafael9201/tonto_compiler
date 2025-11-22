cmake_minimum_required(VERSION 3.0.0)
project(Tonto)

# Configuração do C++
# set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_STANDARD 17)

# Configuração do Flex
find_package(FLEX)
FLEX_TARGET(Lexer lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.cc COMPILE_FLAGS "-+")

# Configuração do Bison
find_package(BISON)
BISON_TARGET(Parser parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp DEFINES_FILE "${CMAKE_CURRENT_BINARY_DIR}/parser.h")

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_SOURCE_DIR})

# Executável depende da saída do Flex e do Bison
set(TONTO_SOURCES
${FLEX_Lexer_OUTPUTS}
${BISON_Parser_OUTPUTS}
globals.cpp
)

add_executable(tonto ${TONTO_SOURCES})