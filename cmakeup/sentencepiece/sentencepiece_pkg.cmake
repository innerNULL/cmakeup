# file: sentencepiece_pkg.cmake
# date: 2021-01-06


include(FetchContent)

if(${CMAKE_VERSION} VERSION_LESS 3.14)
    include(add_FetchContent_MakeAvailable.cmake)
endif()

set(FETCHCONTENT_QUIET FALSE)   
set(TARGET_GIT_URL "https://github.com/google/sentencepiece.git")
set(TARGET_TAG "master")
set(TARGET_URL "https://github.com/google/sentencepiece/archive/master.zip")


#FetchContent_Declare(
#    sentencepiece   
#    GIT_REPOSITORY ${TARGET_GIT_URL}
#    GIT_TAG ${TARGET_GIT_TAG} 
#    GIT_PROGRESS TRUE
#)

FetchContent_Declare(
  sentencepiece 
  URL ${TARGET_URL} 
)


FetchContent_GetProperties(sentencepiece)
if (NOT sentencepiece_POPULATED)
  FetchContent_Populate(sentencepiece)
  add_subdirectory(${sentencepiece_SOURCE_DIR} ${sentencepiece_BINARY_DIR} EXCLUDE_FROM_ALL)
  set_target_properties(
    sentencepiece-static
    sentencepiece_train-static
    PROPERTIES COMPILE_FLAGS "-Wno-all -Wno-extra -Wno-error"
  )
  include_directories(${sentencepiece_SOURCE_DIR}/src)
  #set(INCLUDE_DIRECTORIES
  #  PRIVATE
  #  ${sentencepiece_SOURCE_DIR}/src
  #)
  MESSAGE(NOTICE 
      "You Needs Add `target_link_libraries(\$\{your_executable_file\} PRIVATE sentencepiece)` in You Root CMakeLists.txt.")
endif()
