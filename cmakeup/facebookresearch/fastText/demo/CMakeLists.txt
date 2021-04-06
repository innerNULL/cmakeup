# file: CMakeLists.txt
# date: 2021-01-07

 
cmake_minimum_required(VERSION 3.14)
project(demo4Tokenizer)
#set(CMAKE_CXX_STANDARD 17)


set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS " -pthread -std=c++17 -funroll-loops -O3 -march=native")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")


include(ExternalProject)
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/..;${CMAKE_MODULE_PATH}")
include(fastText_pkg)


set(DEMO ./main.cpp)
add_executable(main ${DEMO})
target_link_libraries(main PRIVATE ${fastText_lib})
