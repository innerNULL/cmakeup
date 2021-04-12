# file: FTAPI4CPP_pkg.cmake
# date: 2021-01-15

include(ExternalProject)


set(THIRDPARTY_ROOT "./_3rdparty")
set(VERSION "4.0.1300")
set(TARGET_URL "https://softwarefile.futunn.com/FTAPI-${VERSION}.7z")
execute_process(COMMAND pwd OUTPUT_VARIABLE CURR_PATH)
string(REPLACE "\n" "" CURR_PATH ${CURR_PATH})
get_filename_component(CURR_PATH ${CURR_PATH} ABSOLUTE)

message(STATUS "This needs decompression of 7z file, so you need install p7zip as run `apt install p7zip-full`")
if(EXISTS "${THIRDPARTY_ROOT}/FTAPI-${VERSION}")
  message(STATUS "${THIRDPARTY_ROOT}/FTAPI-${VERSION} exists")
else()
  execute_process(COMMAND wget ${TARGET_URL})
  execute_process(COMMAND 7za x FTAPI-${VERSION}.7z)
  execute_process(COMMAND mkdir -p ${THIRDPARTY_ROOT})
  execute_process(COMMAND mv FTAPI-${VERSION} ${THIRDPARTY_ROOT})
  execute_process(COMMAND mv FTAPI-${VERSION}.7z ${THIRDPARTY_ROOT})
endif()


set(FTAPI4CPP_header "${CURR_PATH}/${THIRDPARTY_ROOT}/FTAPI-${VERSION}/FTAPI4CPP/Include")
set(FTAPI4CPP_shared_lib_path "${CURR_PATH}/${THIRDPARTY_ROOT}/FTAPI-${VERSION}/FTAPI4CPP/Bin/Ubuntu16.04")
include_directories(${FTAPI4CPP_header})
set(FTAPI4CPP_shared_lib 
  "${FTAPI4CPP_shared_lib_path}/libFTAPI.a;${FTAPI4CPP_shared_lib_path}/libFTAPIChannel.so;${FTAPI4CPP_shared_lib_path}/libprotobuf.a;pthread;${CMAKE_DL_LIBS}"
)
message(STATUS "FTAPI4CPP_header=${FTAPI4CPP_header}")
message(STATUS "FTAPI4CPP_shared_lib=${FTAPI4CPP_shared_lib}")
message(STATUS "You should add `target_link_libraries($\{you_executable_file\} \"${FTAPI4CPP_shared_lib}\")`")
