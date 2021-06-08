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

execute_process(COMMAND bash -c "${CMAKEUP_VCPKG_BIN} install sqlite3")

message(STATUS "All vcpkg pkg are installed under ${CMAKEUP_VCPKG_ROOT}/packages")

# The following is done in `integrate_vcpkg`.
#include(${CMAKEUP_VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake)

find_package(unofficial-sqlite3 CONFIG REQUIRED)


add_executable(example "example.cpp")
target_link_libraries(example PRIVATE unofficial::sqlite3::sqlite3)

