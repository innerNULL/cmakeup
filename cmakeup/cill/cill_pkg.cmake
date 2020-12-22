# file: cill_pkg.cmake
# date: 2020-12-21


include(FetchContent)

if(${CMAKE_VERSION} VERSION_LESS 3.14)
    include(add_FetchContent_MakeAvailable.cmake)
endif()

set(FETCHCONTENT_QUIET FALSE)
set(CILL_GIT_TAG "")
set(CILL_GIT_URL https://github.com/innerNULL/cill.git)

FetchContent_Declare(
    cill  
    GIT_REPOSITORY ${CILL_GIT_URL} 
    GIT_TAG ${CILL_GIT_TAG} 
    GIT_PROGRESS TRUE 
)

#FetchContent_MakeAvailable(cill)
FetchContent_GetProperties(cill)
if (NOT cill_POPULATED)
    FetchContent_Populate(cill)
    #add_subdirectory(${cill_SOURCE_DIR} ${cill_BINARY_DIR})
    include_directories(${cill_SOURCE_DIR}/include)
    MESSAGE(STATUS "cill_pkg_root_path = ${cill_SOURCE_DIR}/include") 
endif ()
