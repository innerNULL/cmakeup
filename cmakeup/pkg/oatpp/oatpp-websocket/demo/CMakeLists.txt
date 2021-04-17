# file: CMakeLists.txt
# date: 2021-01-07

 
cmake_minimum_required(VERSION 3.14)
project(demo)


set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS " -pthread -std=c++11 -funroll-loops -O3 -march=native")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")


include(ExternalProject)
#set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/..;${CMAKE_MODULE_PATH}")
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/..;${CMAKE_MODULE_PATH}")
include(oatpp-websocket_pkg) 
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../oatpp-mbedtls/;${CMAKE_MODULE_PATH}")
include(oatpp-mbedtls_pkg)


set(DEMO ./demo.cpp)
add_executable(demo ${DEMO})
target_link_libraries(demo PUBLIC ${oatpp-websocket_lib})
target_link_libraries(demo PUBLIC ${oatpp-mbedtls_lib} mbedtls::TLS mbedtls::X509 mbedtls::Crypto)
