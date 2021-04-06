# file: abseil-cpp_pkg.cmake 
# date: 2021-03-31


cmake_minimum_required(VERSION 2.8.12)
set(CMAKE_CXX_STANDARD 11)

set(THIRDPARTY_ROOT "./_3rdparty")
set(VERSION "1.8.5")
set(ORGANIZATION "gabime")
set(RESPOSITORY "spdlog")

# https://github.com/gabime/spdlog/archive/refs/tags/v1.8.5.zip
set(PROJ ${ORGANIZATION}/${RESPOSITORY})
set(TARGET_URL "https://github.com/${ORGANIZATION}/${RESPOSITORY}/archive/refs/tags/v${VERSION}.zip")
execute_process(COMMAND pwd OUTPUT_VARIABLE CURR_PATH)
string(REPLACE "\n" "" CURR_PATH ${CURR_PATH})
get_filename_component(CURR_PATH ${CURR_PATH} ABSOLUTE)

set(SRC_FOLDER_NAME ${RESPOSITORY}-${VERSION})


if(EXISTS "${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}")
  message(STATUS "${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME} exists")
else()
  execute_process(COMMAND wget ${TARGET_URL})
  execute_process(COMMAND unzip v${VERSION}.zip)
  execute_process(COMMAND mkdir -p ${THIRDPARTY_ROOT})
  execute_process(COMMAND mv ${SRC_FOLDER_NAME} ${THIRDPARTY_ROOT})
  execute_process(COMMAND mv v${VERSION}.zip ${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}.zip)
endif()


set(${RESPOSITORY}_include_path
  "${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/include")
message(STATUS "${RESPOSITORY}_include_path: ${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/include")

include_directories(${${RESPOSITORY}_include_path})
#message(STATUS "You should add `target_link_libraries(\${TARGET_BIN} absl::xxxx})` for target-bin.")
