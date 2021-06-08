# file: vcpkg_helpers.cmake
# date: 2021-06-08


macro(get_vcpkg_src url target_path)
    #if(EXISTS "${target_path}/vcpkg_src.zip")
    if(EXISTS "${target_path}/vcpkg_src")
        message(STATUS "vcpkg src has been downloaded.")
    else()
        execute_process(COMMAND bash -c "cd ${target_path} && wget ${url} -O vcpkg_src.zip")
        execute_process(COMMAND bash -c "cd ${target_path} && unzip vcpkg_src.zip")
        execute_process(COMMAND bash -c "rm vcpkg_src.zip && mv vcpkg-* vcpkg_src")
    endif()
endmacro(get_vcpkg_src)


macro(build_vcpkg vcpkg_src_root)
    unset(CMAKE_TOOLCHAIN_FILE CACHE)
    set(CMAKE_TOOLCHAIN_FILE ${vcpkg_src_root}/scripts/buildsystems/vcpkg.cmake
        CACHE STRING "Vcpkg toolchain file")

    unset(CMAKEUP_VCPKG_ROOT CACHE)
    set(CMAKEUP_VCPKG_ROOT "${vcpkg_src_root}" 
        CACHE STRING "cmakeup integrated vcpkg root path.")

    unset(CMAKEUP_VCPKG_BIN CACHE)
    set(CMAKEUP_VCPKG_BIN "${vcpkg_src_root}/vcpkg" 
        CACHE STRING "cmakeup global vars")

    include(${vcpkg_src_root}/scripts/buildsystems/vcpkg.cmake)

    if(EXISTS ${CMAKEUP_VCPKG_BIN})
        message(STATUS "`CMAKEUP_VCPKG_BIN` already exists, located at ${CMAKEUP_VCPKG_BIN}")
    else()
        execute_process(COMMAND bash -c "${vcpkg_src_root}/bootstrap-vcpkg.sh")
    endif()
endmacro(build_vcpkg)


macro(integrate_vcpkg url target_path)
    get_vcpkg_src(${url} ${target_path})
    build_vcpkg("${target_path}/vcpkg_src")
endmacro(integrate_vcpkg)

