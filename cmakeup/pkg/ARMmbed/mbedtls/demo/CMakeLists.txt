# file: CMakeLists.txt
# date: 2021-01-07

 
cmake_minimum_required(VERSION 3.14)
project(demo)
set(CMAKE_CXX_STANDARD 17)


set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")


include(ExternalProject)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../../module;${CMAKE_MODULE_PATH}")
include(cmakeup)
cmakeup_init("./_cmakeup_dep" "https://ghproxy.com/") 

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/..;${CMAKE_MODULE_PATH}") 
include(mbedtls_pkg)


cmakeup_global_vars_printer()
set(DEMO ./demo.cpp)
add_executable(demo ${DEMO})
target_link_libraries(demo PUBLIC ${CMAKEUP_STATIC_LIB_ARMmbed_mbedtls_master})
