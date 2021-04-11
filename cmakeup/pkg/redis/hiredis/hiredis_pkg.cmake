# file: facebookresearch_fastText.cmake
# date: 2021-03-12


cmake_minimum_required(VERSION 2.8.12)

set(THIRDPARTY_ROOT "./_3rdparty")
set(VERSION "master")
set(ORGANIZATION "redis")
set(RESPOSITORY "hiredis")


# https://github.com/redis/hiredis/archive/refs/heads/master.zip
set(PROJ ${ORGANIZATION}/${RESPOSITORY})
set(TARGET_URL "https://github.com/${PROJ}/archive/refs/heads/${VERSION}.zip")
execute_process(COMMAND pwd OUTPUT_VARIABLE CURR_PATH)
string(REPLACE "\n" "" CURR_PATH ${CURR_PATH})
get_filename_component(CURR_PATH ${CURR_PATH} ABSOLUTE)

set(SRC_FOLDER_NAME ${RESPOSITORY}-${VERSION})


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
  "${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}")
set(${RESPOSITORY}_lib 
  "${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/build/libhiredis_static.a")

message(STATUS "${RESPOSITORY}_include_path: ${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/src")
message(STATUS "${RESPOSITORY}_lib: ${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/build/libfasttext.a")

include_directories(${${RESPOSITORY}_include_path})
message(STATUS "You should add `target_link_libraries(\${TARGET_BIN} PUBLIC \${${RESPOSITORY}_lib})` for target-bin.")
