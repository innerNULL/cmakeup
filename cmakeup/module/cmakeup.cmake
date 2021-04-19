# file: cmakeup.cmake
# date: 2021-04-18


macro(cmakeup_log func_name log_str)
    message(STATUS "[cmakeup.${func_name}] ${log_str}")
endmacro(cmakeup_log)


macro(set_curr_path)
    execute_process(COMMAND pwd OUTPUT_VARIABLE CURR_PATH)
    string(REPLACE "\n" "" CURR_PATH ${CURR_PATH})
    get_filename_component(CURR_PATH ${CURR_PATH} ABSOLUTE)
    cmakeup_log("set_curr_path" "Current path: ${CURR_PATH}.")
endmacro(set_curr_path)


macro(set_cmakeup_global_var cmakeup_dep_path cmakeup_github_proxy)
    cmakeup_log("set_cmakeup_global_var" "Setting global vars.")
    set_curr_path()
    
    unset(CMAKEUP_DEP_ROOT CACHE)
    set(CMAKEUP_DEP_ROOT "${CURR_PATH}/${cmakeup_dep_path}" CACHE STRING "cmakeup dep root path")
    execute_process(COMMAND mkdir -p ${CMAKEUP_DEP_ROOT})

    unset(CMAKEUP_GITHUB_PROXY CACHE)
    set(CMAKEUP_GITHUB_PROXY ${cmakeup_github_proxy} CACHE STRING "cmakeup github proxy")

    cmakeup_log("set_cmakeup_global_var" "Sets CMAKEUP_DEP_ROOT as '${CMAKEUP_DEP_ROOT}'.")
    cmakeup_log("set_cmakeup_global_var" "Set CMAKEUP_GITHUB_PROXY as '${CMAKEUP_GITHUB_PROXY}'.")
    cmakeup_log("set_cmakeup_global_var" "Finished setting global vars.")
endmacro(set_cmakeup_global_var)


macro(set_github_pkg org respository branch github_proxy)
    cmakeup_log("set_github_pkg" "Setting package.")

    #set(BRANCH "master")
    #set(ORGANIZATION "oatpp")
    #set(RESPOSITORY "oatpp-mbedtls")
    #set(GIT_PROXY "https://ghproxy.com/")

    set(ORGANIZATION ${org})
    set(RESPOSITORY ${respository})
    set(BRANCH ${branch})

    if(${github_proxy} STREQUAL global)
        set(GITHUB_PROXY ${CMAKEUP_GITHUB_PROXY})
        cmakeup_log("set_github_pkg" "Sets GITHUB_PROXY with CMAKEUP_GITHUB_PROXY: ${GITHUB_PROXY}.")
    else()
        set(GITHUB_PROXY ${github_proxy})
        cmakeup_log("set_github_pkg" "Sets GITHUB_PROXY as: ${GITHUB_PROXY}.") 
    endif()

    set(PROJ ${ORGANIZATION}/${RESPOSITORY})
    set(TARGET_URL "${GITHUB_PROXY}https://github.com/${PROJ}/archive/refs/heads/${BRANCH}.zip")

    set(PKG_DEP_ROOT ${CMAKEUP_DEP_ROOT}/${ORGANIZATION}/${RESPOSITORY}/${BRANCH})
    execute_process(COMMAND mkdir -p ${PKG_DEP_ROOT})
    cmakeup_log("set_github_pkg" "PKG_DEP_ROOT: ${PKG_DEP_ROOT}")

    set(CMAKEUP_DEP_SRC_FOLDER ${RESPOSITORY}-${BRANCH})
    set(CMAKEUP_DEP_SRC_PATH ${PKG_DEP_ROOT}/${CMAKEUP_DEP_SRC_FOLDER})

    cmakeup_log("set_github_pkg" "Finished setting package: ${TARGET_URL}")
endmacro(set_github_pkg)


macro(get_git_pkg target_url pkg_dep_root branch src_dir_name)
    if(EXISTS "${pkg_dep_root}/${branch}.zip")
        cmakeup_log("get_git_pkg" "Pkg zip file ${pkg_dep_root}/${branch}.zip already exists.")
    else()
        execute_process(COMMAND wget ${target_url} WORKING_DIRECTORY ${pkg_dep_root})
        execute_process(COMMAND unzip ${BRANCH}.zip WORKING_DIRECTORY ${pkg_dep_root})
    endif()
endmacro(get_git_pkg)


macro(init_github_pkg org respository branch github_proxy)
    set_github_pkg(${org} ${respository} ${branch} ${github_proxy})
    get_git_pkg(${TARGET_URL} ${PKG_DEP_ROOT} ${BRANCH} ${CMAKEUP_DEP_SRC_FOLDER})
endmacro(init_github_pkg)


macro(cmake_build src_dir_path cmake_args make_args)
    set(CMAKE_CMD "cmake ../ ${cmake_args}")
    set(MAKE_CMD "make ${make_args}")

    execute_process(COMMAND mkdir -p ${src_dir_path}/build)
    execute_process(COMMAND cmake ../ ${cmake_args} WORKING_DIRECTORY ${src_dir_path}/build)
    execute_process(COMMAND make ${make_args} WORKING_DIRECTORY ${src_dir_path}/build)

    cmakeup_log("cmake_build" "Executing build at ${src_dir_path}/build.")
    cmakeup_log("cmake_build" "Finished execute cmake cmd: ${CMAKE_CMD}")
    cmakeup_log("cmake_build" "Finished execute make cmd: ${MAKE_CMD}")
endmacro(cmake_build)

