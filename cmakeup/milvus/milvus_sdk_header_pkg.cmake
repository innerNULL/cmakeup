# file: milvus_sdk_header_pkg.cmake   
# date: 2020-12-22


include(FetchContent)

if(${CMAKE_VERSION} VERSION_LESS 3.14)
    include(add_FetchContent_MakeAvailable.cmake)
endif()


# Too slow since Chinese Great Great Wall!
#set(FETCHCONTENT_QUIET FALSE) 
#set(MILVUS_SDK_GIT_TAG "master")
#set(MILVUS_SDK_GIT_URL "https://github.com/milvus-io/milvus.git")

#FetchContent_Declare(
#    milvus_sdk_header   
#    GIT_REPOSITORY ${MILVUS_SDK_GIT_URL}
#    GIT_TAG ${MILVUS_GIT_TAG} 
#    GIT_PROGRESS TRUE
#)

set(FETCHCONTENT_QUIET FALSE) 
set(MILVUS_SDK_GIT_TAG "master")
set(MILVUS_SDK_GIT_URL "https://github.com/milvus-io/milvus/archive/${MILVUS_SDK_GIT_TAG}.zip")

FetchContent_Declare(
    milvus_sdk_header   
    URL ${MILVUS_SDK_GIT_URL}
    GIT_PROGRESS TRUE
)



FetchContent_GetProperties(milvus_sdk_header)
if (NOT milvus_sdk_header_POPULATED)
    FetchContent_Populate(milvus_sdk_header)
    include_directories(${milvus_sdk_header_SOURCE_DIR}/sdk/include EXCLUDE_FROM_ALL)
    include_directories(${milvus_sdk_header_SOURCE_DIR}/sdk EXCLUDE_FROM_ALL) # Since milvus will includes thirdparty localed at this path
    MESSAGE(STATUS "milvus_sdk_header_pkg_root_path = ${milvus_sdk_header_SOURCE_DIR}/sdk/include")
    MESSAGE(NOTICE 
        "[NOTE] - "
        "You Needs First pre-compile milvus sdk to generate 'libmilvus_sdk.so' File and Put It into \$\{milvus_sdk_dll_path\}, "
        "Then Adds `set(MILVUS_SDK_LIB \$\{milvus_sdk_dll_path\}/libmilvus_sdk.so)` in Your Root CMakeLists.txt.")
    MESSAGE(NOTICE 
        "[NOTE] - "
        "You Needs Add `target_link_libraries(dep_test PRIVATE \$\{MILVUS_SDK_LIB\} pthread)` in Your Root CMakeLists.txt.")
endif ()

