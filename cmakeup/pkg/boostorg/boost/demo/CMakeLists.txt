# file: CMakeLists.txt
# date: 2021-04-22

 
cmake_minimum_required(VERSION 3.14)
project(demo)
set(CMAKE_CXX_STANDARD 17)


set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")


include(ExternalProject)

set(CMKAEUP_ROOT_PATH "${CMAKE_SOURCE_DIR}/../../../..")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMKAEUP_ROOT_PATH}/module")
include(cmakeup)
cmakeup_init("${CMAKE_CURRENT_SOURCE_DIR}/build/_cmakeup_hub" "https://ghproxy.com/")
cmakeup_root_path_register(${CMKAEUP_ROOT_PATH})

cmakeup_pkg_cmake_importer("boostorg" "boost")
cmakeup_integrate_boostorg_boost("1.76.0" "./cmakeup_install" "none")


cmakeup_global_vars_printer()

set(WS_CLIENT_DEMO ./ws_client_demo.cpp)
add_executable(ws_client_demo ${WS_CLIENT_DEMO})
target_link_libraries(ws_client_demo PUBLIC ${Boost_LIBRARIES})

set(WSS_CLIENT_DEMO ../wss_client_demo.cpp)
add_executable(wss_client_demo ${WSS_CLIENT_DEMO})
# You can link boost by seperately ling `${Boost_LIBRARIES}` and its dependencies, 
# such as openssl
target_link_libraries(wss_client_demo PUBLIC ${Boost_LIBRARIES})
target_link_libraries(wss_client_demo PUBLIC OpenSSL::SSL)
