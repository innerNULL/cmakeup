# file: cppzmq_pkg.cmake 
# date: 2021-04-09


cmake_minimum_required(VERSION 2.8.12)
set(CMAKE_CXX_STANDARD 11)

set(THIRDPARTY_ROOT "./_3rdparty")
set(VERSION "master")
set(ORGANIZATION "zeromq")
set(RESPOSITORY "cppzmq")

# https://github.com/zeromq/cppzmq/archive/refs/heads/master.zip 
set(PROJ ${ORGANIZATION}/${RESPOSITORY})
set(TARGET_URL "https://github.com/${ORGANIZATION}/${RESPOSITORY}/archive/refs/heads/${VERSION}.zip")
execute_process(COMMAND pwd OUTPUT_VARIABLE CURR_PATH)
string(REPLACE "\n" "" CURR_PATH ${CURR_PATH})
get_filename_component(CURR_PATH ${CURR_PATH} ABSOLUTE)

set(SRC_FOLDER_NAME ${RESPOSITORY}-${VERSION})


if(EXISTS "${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}")
  message(STATUS "${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME} exists")
else()
  execute_process(COMMAND wget https://raw.githubusercontent.com/innerNULL/cmakeup/main/cmakeup/pkg/zeromq/libzmq/libzmq_pkg.cmake)
  execute_process(COMMAND wget ${TARGET_URL})
  execute_process(COMMAND unzip ${VERSION}.zip)
  execute_process(COMMAND mkdir -p ${THIRDPARTY_ROOT})
  execute_process(COMMAND mv ${SRC_FOLDER_NAME} ${THIRDPARTY_ROOT})
  execute_process(COMMAND mv ${VERSION}.zip ${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}.zip)
endif()


set(${RESPOSITORY}_include_path
  "${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}")
message(STATUS "${RESPOSITORY}_include_path: ${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}")

include_directories(${${RESPOSITORY}_include_path})
#message(STATUS "You should add `target_link_libraries(\${TARGET_BIN} absl::xxxx})` for target-bin.")
