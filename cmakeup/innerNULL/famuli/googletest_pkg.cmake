# file: googletest_pkg.cmake
# date: 2021-02-01

cmake_minimum_required(VERSION 2.8.12)

set(THIRDPARTY_ROOT "./_3rdparty")
set(VERSION "master")
set(TARGET_URL "https://github.com/google/googletest/archive/${VERSION}.zip")
execute_process(COMMAND pwd OUTPUT_VARIABLE CURR_PATH)
string(REPLACE "\n" "" CURR_PATH ${CURR_PATH})
get_filename_component(CURR_PATH ${CURR_PATH} ABSOLUTE)

set(SRC_FOLDER_NAME googletest-${VERSION})


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


set(googletest_include_path
  "${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/googletest/include;${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/googlemock/include")
set(googletest  
  "${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/build/lib/libgtest.a;${CURR_PATH}/${THIRDPARTY_ROOT}/${SRC_FOLDER_NAME}/build/lib/libgtest_main.a"
)
#add_library(googletest STATIC IMPORTED)
#set_target_properties(googletest 
#  PROPERTIES 
#      INCLUDE_DIRECTORIES ${GOOGLETEST_INCLUDE_PATH}
#      IMPORTED_LOCATION ${GOOGLETEST_STATIC_LIB}
#)
include_directories(${googletest_include_path})

message(STATUS "You should add `target_link_libraries(cill_tests PRIVATE \${googletest})` for your googletest depending exec")
