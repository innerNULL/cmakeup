# file: spdlog_pkg.cmake
# date: 2020-12-21


include(FetchContent)

if(${CMAKE_VERSION} VERSION_LESS 3.14)
    include(add_FetchContent_MakeAvailable.cmake)
endif()

set(FETCHCONTENT_QUIET FALSE)     
set(SPDLOG_GIT_URL "https://github.com/gabime/spdlog.git")
set(SPDLOG_GIT_TAG "v1.x")

FetchContent_Declare(
    spdlog  
    GIT_REPOSITORY ${SPDLOG_GIT_URL}
    GIT_TAG ${SPDLOG_GIT_TAG} 
    GIT_PROGRESS TRUE
)


FetchContent_GetProperties(spdlog)
if (NOT spdlog_POPULATED)
    FetchContent_Populate(spdlog)
    add_subdirectory(${spdlog_SOURCE_DIR} ${spdlog_BINARY_DIR} EXCLUDE_FROM_ALL)
    MESSAGE(STATUS "spdlog_pkg_root_path = ${spdlog_SOURCE_DIR}")
    MESSAGE(NOTICE 
        "You Needs Add `target_link_libraries(\$\{your_executable_file\} PRIVATE spdlog)` in You Root CMakeLists.txt.")
endif ()

