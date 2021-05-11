# file: CMakeLists.txt
# date: 2021-01-07

 
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

cmakeup_pkg_cmake_importer("oatpp" "oatpp-websocket")
cmakeup_integrate_oatpp_oatpp_websocket("master" "null" "global" "full")


set(ECHO_WS_DEMO ./echo_ws_demo.cpp)
add_executable(echo_ws_demo ${ECHO_WS_DEMO})
target_link_libraries(echo_ws_demo 
    PUBLIC -Wl,--start-group 
    PUBLIC ${CMAKEUP_STATIC_LIB_oatpp_oatpp_master}
    PUBLIC ${CMAKEUP_STATIC_LIB_oatpp_oatpp-websocket_master}
    PUBLIC ${CMAKEUP_STATIC_LIB_oatpp_oatpp-mbedtls_master}
    PUBLIC ${CMAKEUP_STATIC_LIB_ARMmbed_mbedtls_master}
    PUBLIC -Wl,--end-group
)


set(ALPACA_WSS_DEMO ./alpaca_wss_demo.cpp)
add_executable(alpaca_wss_demo ${ALPACA_WSS_DEMO})
target_link_libraries(alpaca_wss_demo  
    PUBLIC -Wl,--start-group 
    PUBLIC ${CMAKEUP_STATIC_LIB_oatpp_oatpp_master}
    PUBLIC ${CMAKEUP_STATIC_LIB_oatpp_oatpp-websocket_master}
    PUBLIC ${CMAKEUP_STATIC_LIB_oatpp_oatpp-mbedtls_master}
    PUBLIC ${CMAKEUP_STATIC_LIB_ARMmbed_mbedtls_master}
    PUBLIC -Wl,--end-group
)
