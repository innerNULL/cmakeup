# file: json_pkg.cmake
# date: 2020-12-21


include(FetchContent)

if(${CMAKE_VERSION} VERSION_LESS 3.14)
    include(add_FetchContent_MakeAvailable.cmake)
endif()

set(FETCHCONTENT_QUIET FALSE)     
set(JSON_GIT_URL "https://github.com/ArthurSonzogni/nlohmann_json_cmake_fetchcontent.git")

FetchContent_Declare(
    json  
    GIT_REPOSITORY ${JSON_GIT_URL} 
    GIT_PROGRESS TRUE
)

#FetchContent_MakeAvailable(cill)
FetchContent_GetProperties(json)
if (NOT json_POPULATED)
    FetchContent_Populate(json)
    add_subdirectory(${json_SOURCE_DIR} ${json_BINARY_DIR} EXCLUDE_FROM_ALL)
    MESSAGE(STATUS "json_pkg_root_path = ${json_SOURCE_DIR}")
    MESSAGE(NOTICE 
        "You Needs Add `target_link_libraries(\$\{your_executable_file\} PRIVATE nlohmann_json)` in You Root CMakeLists.txt.")
endif ()

