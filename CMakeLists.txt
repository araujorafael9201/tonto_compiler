cmake_minimum_required(VERSION 3.0.0)
project(Tonto)

# Configuração do C++
# set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_STANDARD 17)

# Configuração do Flex
find_package(FLEX)
FLEX_TARGET(Lexer lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.cc COMPILE_FLAGS "-+")
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_SOURCE_DIR})


# Executável depende da saída do Flex
add_executable(tonto ${FLEX_Lexer_OUTPUTS})