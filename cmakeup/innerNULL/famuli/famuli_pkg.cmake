# file: famuli_pkg.cmake 
# date: 2021-04-08


cmake_minimum_required(VERSION 2.8.12)

set(CMAKE_CXX_FLAGS " -pthread -std=c++17 -funroll-loops -O3 -march=native")

set(THIRDPARTY_ROOT "./_3rdparty")
set(VERSION "main")
set(ORGANIZATION "innerNULL")
set(RESPOSITORY "famuli")


# https://github.com/innerNULL/famuli/archive/refs/heads/main.zip
set(PROJ ${ORGANIZATION}/${RESPOSITORY})
set(TARGET_URL "https://github.com/${ORGANIZATION}/${RESPOSITORY}/archive/refs/heads/${VERSION}.zip")
execute_process(COMMAND pwd OUTPUT_VARIABLE CURR_PATH)
string(REPLACE "\n" "" CURR_PATH ${CURR_PATH})
get_filename_component(CURR_PATH ${CURR_PATH} ABSOLUTE)

set(SRC_FOLDER_NAME ${RESPOSITORY}-${VERSION})

message(STATUS "TARGET_URL: ${TARGET_URL}")

if(EXISTS "${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}")
  message(STATUS "${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME} exists")
else()
  execute_process(COMMAND wget ${TARGET_URL})
  execute_process(COMMAND unzip ${VERSION}.zip)
  execute_process(COMMAND mkdir -p ${THIRDPARTY_ROOT})
  execute_process(COMMAND mv ${SRC_FOLDER_NAME} ${THIRDPARTY_ROOT})
  execute_process(COMMAND mv ${VERSION}.zip ${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}.zip)
  execute_process(COMMAND mkdir -p ${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/build)
  execute_process(COMMAND cmake ../ -DBUILD_GMOCK=OFF WORKING_DIRECTORY ${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/build)
  execute_process(COMMAND make -j8 WORKING_DIRECTORY ${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/build)
endif()

set(${RESPOSITORY}_include_path
  "${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/include")
message(STATUS "${RESPOSITORY}_include_path: ${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/include")

include_directories(${${RESPOSITORY}_include_path})
