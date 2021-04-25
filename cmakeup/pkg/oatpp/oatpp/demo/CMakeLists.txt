# file: CMakeLists.txt
# date: 2021-01-07

 
cmake_minimum_required(VERSION 3.14)
project(demo)


set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS " -pthread -std=c++17 -funroll-loops -O3 -march=native")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")


include(ExternalProject)

set(CMKAEUP_ROOT_PATH "${CMAKE_SOURCE_DIR}/../../../..")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMKAEUP_ROOT_PATH}/module")
include(cmakeup)
cmakeup_init("./_cmakeup_hub" "https://ghproxy.com/https://github.com")
cmakeup_root_path_register(${CMKAEUP_ROOT_PATH})

cmakeup_pkg_cmake_importer("oatpp" "oatpp")
cmakeup_integrate_oatpp_oatpp("master" "./install" "global")


cmakeup_global_vars_printer()
set(DEMO ./demo.cpp)
add_executable(demo ${DEMO})
target_link_libraries(demo PUBLIC ${CMAKEUP_STATIC_LIB_oatpp_oatpp_master})

