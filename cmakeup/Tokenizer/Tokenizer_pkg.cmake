# file: Tokenizer_pkg.cmake
# date: 2021-01-07


include(FetchContent)

if(${CMAKE_VERSION} VERSION_LESS 3.14)
  include(add_FetchContent_MakeAvailable.cmake)
endif()

set(FETCHCONTENT_QUIET FALSE)     
set(TARGET_GIT_URL "https://github.com/OpenNMT/Tokenizer.git")
set(TARGET_GIT_TAG "master")

FetchContent_Declare(
  tokenizer 
  GIT_REPOSITORY ${TARGET_GIT_URL}
  GIT_TAG ${YARGET_GIT_TAG} 
  GIT_PROGRESS TRUE
  #PATCH_COMMAND rm -rf ./build && mkdir build && cd build && cmake ../ -DCMAKE_PREFIX_PATH=/usr/local/opt/icu4c && make -j12
  PATCH_COMMAND mkdir -p build && cd build && cmake ../ -DCMAKE_PREFIX_PATH=/usr/local/opt/icu4c && make -j8
)

if (UNIX) 
  list(APPEND CMAKE_PREFIX_PATH "/usr/local/opt/icu4c")
endif()


FetchContent_GetProperties(tokenizer)
if (NOT tokenizer_POPULATED)
  FetchContent_Populate(tokenizer)
  include_directories(${tokenizer_SOURCE_DIR}/include)
  include_directories(${tokenizer_SOURCE_DIR}/build/)
  set(tokenizer_SHARED_LIB "${tokenizer_SOURCE_DIR}/build/libOpenNMTTokenizer.dylib")
  add_library(tokenizer SHARED IMPORTED)
  set_target_properties(tokenizer 
    PROPERTIES IMPORTED_LOCATION ${tokenizer_SHARED_LIB}
  )
  MESSAGE(STATUS "tokenizer_src_root_path = ${tokenizer_SOURCE_DIR}")
  MESSAGE(STATUS "tokenizer_build_root_path = ${tokenizer_SOURCE_DIR}/build")
  MESSAGE(NOTICE 
      "You needs add `target_link_libraries(\$\{your_executable_file\} PRIVATE tokenizer)` in your root CMakeLists.txt.")
  MESSAGE(NOTICE 
      "If rebuild tokenizer, you needs manually remove ${tokenizer_SOURCE_DIR}/build.")
endif ()


