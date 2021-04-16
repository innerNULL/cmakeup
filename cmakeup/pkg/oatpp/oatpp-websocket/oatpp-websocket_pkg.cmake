# file: oatpp-websocket_pkg.cmake
# date: 2021-04-16


cmake_minimum_required(VERSION 2.8.12)

set(THIRDPARTY_ROOT "./_3rdparty")
set(VERSION "master")
set(ORGANIZATION "oatpp")
set(RESPOSITORY "oatpp-websocket")


# Default: https://github.com/oatpp/oatpp-websocket/archive/refs/heads/master.zip 
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
  execute_process(
      COMMAND cmake ../ -D OATPP_MODULES_LOCATION=EXTERNAL -D OATPP_EXTERNAL_SOURCE=URL
      WORKING_DIRECTORY ${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/build)
  execute_process(COMMAND make -j8 WORKING_DIRECTORY ${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/build)
endif()


set(${RESPOSITORY}_include_path
  "${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/src")
set(${RESPOSITORY}_dep_include_path 
    "${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/build/lib_oatpp_external-prefix/src/lib_oatpp_external/src/")
set(${RESPOSITORY}_include_path "${${RESPOSITORY}_include_path};${${RESPOSITORY}_dep_include_path}")

set(${RESPOSITORY}_lib 
  "${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/build/src/liboatpp-websocket.a")
set(${RESPOSITORY}_dep_lib 
  "${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/build/lib_oatpp_external-prefix/src/lib_oatpp_external-build/src/liboatpp.a")
set(${RESPOSITORY}_lib "${${RESPOSITORY}_lib};${${RESPOSITORY}_dep_lib}")

message(STATUS "${RESPOSITORY}_include_path: ${${RESPOSITORY}_include_path}")
message(STATUS "${RESPOSITORY}_lib: ${${RESPOSITORY}_lib}")

include_directories(${${RESPOSITORY}_include_path})
message(STATUS "You should add `target_link_libraries(\${__TARGET_BIN__} PUBLIC \${${RESPOSITORY}_lib})` for target-bin.")
