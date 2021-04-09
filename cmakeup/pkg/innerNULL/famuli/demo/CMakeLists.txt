# file: CMakeLists.txt
# date: 2021-01-07

 
cmake_minimum_required(VERSION 3.14)
project(demo4Tokenizer)
set(CMAKE_CXX_STANDARD 17)


set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")


include(ExternalProject)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/..;${CMAKE_MODULE_PATH}")
# Following are famuli and its using dependencies.
include(famuli_pkg)
include(fastText_pkg)
include(spdlog_pkg)
include(abseil-cpp_pkg)


set(DEMO ./demo.cpp)
add_executable(demo ${DEMO})
# Following are famuli and its using dependencies.
target_link_libraries(demo PUBLIC ${fastText_lib})
target_link_libraries(demo PUBLIC absl::strings)
