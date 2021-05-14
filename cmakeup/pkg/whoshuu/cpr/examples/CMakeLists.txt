# file: CMakeLists.txt
# date: 2021-05-14

 
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
cmakeup_init("${CMAKE_CURRENT_SOURCE_DIR}/build/_cmakeup_hub" "https://ghproxy.com/https://github.com")
cmakeup_root_path_register(${CMKAEUP_ROOT_PATH})

cmakeup_pkg_cmake_importer("whoshuu" "cpr")
cmakeup_integrate_whoshuu_cpr("master" "null" "global")


cmakeup_global_vars_printer()
set(HTTPS_EXAMPLE ./https_example.cpp)
add_executable(https_example ${HTTPS_EXAMPLE})
target_link_libraries(https_example PUBLIC ${CMAKEUP_STATIC_LIB_whoshuu_cpr_master})
#target_link_libraries(example PUBLIC OpenSSL::SSL)
