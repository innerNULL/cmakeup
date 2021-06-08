# file: CMakeLists.txt
# date: 2021-06-01

 
cmake_minimum_required(VERSION 3.14)
project(example)


set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS " -pthread -std=c++17 -funroll-loops -O3 -march=native")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")


set(CMKAEUP_ROOT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../cmakeup")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMKAEUP_ROOT_PATH}/module")
include(vcpkg_helpers)

integrate_vcpkg(
    "https://ghproxy.com/https://github.com/microsoft/vcpkg/archive/refs/heads/master.zip"  
    "${CMAKE_CURRENT_SOURCE_DIR}/build"
)

execute_process(COMMAND bash -c "${CMAKEUP_VCPKG_BIN} install cpr")
execute_process(COMMAND bash -c "${CMAKEUP_VCPKG_BIN} install openssl")

message(STATUS "All vcpkg pkg are installed under ${CMAKEUP_VCPKG_ROOT}/packages")

# The following is done in `integrate_vcpkg`.
#include(${CMAKEUP_VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake)

find_package(cpr CONFIG REQUIRED)
find_package(OpenSSL REQUIRED) 


add_executable(http_client_example "http_client_example.cpp")
target_link_libraries(http_client_example PUBLIC cpr)

add_executable(https_client_example "https_client_example.cpp")
target_link_libraries(https_client_example PUBLIC cpr)
target_link_libraries(https_client_example PUBLIC OpenSSL::SSL OpenSSL::Crypto)

