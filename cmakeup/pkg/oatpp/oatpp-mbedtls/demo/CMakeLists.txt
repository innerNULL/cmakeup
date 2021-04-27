# file: CMakeLists.txt
# date: 2021-04-17

 
cmake_minimum_required(VERSION 3.14)
project(demo)


set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS " -pthread -std=c++11 -funroll-loops -O3 -march=native")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")


include(ExternalProject)

set(CMKAEUP_ROOT_PATH "${CMAKE_SOURCE_DIR}/../../../..")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMKAEUP_ROOT_PATH}/module")
include(cmakeup)
cmakeup_init("${CMAKE_CURRENT_SOURCE_DIR}/build/_cmakeup_hub" "https://ghproxy.com/https://github.com")
#cmakeup_init("./_cmakeup_hub" "https://ghproxy.com/https://github.com")     
cmakeup_root_path_register(${CMKAEUP_ROOT_PATH})

cmakeup_pkg_cmake_importer("oatpp" "oatpp-mbedtls")
cmakeup_integrate_oatpp_oatpp_mbedtls("master" "./install" "global" "full")


set(DEMO ./demo.cpp)
add_executable(demo ${DEMO})
target_link_libraries(demo PUBLIC ${CMAKEUP_STATIC_LIB_oatpp_oatpp-mbedtls_master})
#target_link_libraries(demo PUBLIC ${oatpp-mbedtls_lib} mbedtls::TLS mbedtls::X509 mbedtls::Crypto)
target_link_libraries(demo PUBLIC ${CMAKEUP_STATIC_LIB_ARMmbed_mbedtls_master})
target_link_libraries(demo PUBLIC ${CMAKEUP_STATIC_LIB_oatpp_oatpp_master})
