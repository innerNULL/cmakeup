# file: CMakeLists.txt
# date: 2021-04-09

 
cmake_minimum_required(VERSION 3.14)
project(demo)
#set(CMAKE_CXX_STANDARD 17)


set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS " -pthread -std=c++17 -funroll-loops -O3 -march=native")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")


include(ExternalProject)
#set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/..;${CMAKE_MODULE_PATH}")
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/..;${CMAKE_MODULE_PATH}") 
include(librdkafka_pkg)


set(DEMO ./demo.cpp)
add_executable(demo ${DEMO})
target_link_libraries(demo PUBLIC ${librdkafka_lib})
