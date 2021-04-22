# file: cmakeup.cmake
# date: 2021-04-18


# cmakeup log marco
macro(cmakeup_log func_name log_str)
    message(STATUS "[cmakeup.${func_name}] ${log_str}")
endmacro(cmakeup_log)


# get current building absolute path
macro(set_curr_path)
    execute_process(COMMAND pwd OUTPUT_VARIABLE CURR_PATH)
    string(REPLACE "\n" "" CURR_PATH ${CURR_PATH})
    get_filename_component(CURR_PATH ${CURR_PATH} ABSOLUTE)
    cmakeup_log("set_curr_path" "Current path: ${CURR_PATH}.")
endmacro(set_curr_path)


# record cmakeup caching global vars
macro(cmakeup_global_vars_recorder append_global_var)
    list(APPEND CMAKEUP_GLOBAL_VARS ${append_global_var})
    cmakeup_log(cmakeup_global_vars_recorder "Register ${append_global_var} into CMAKEUP_GLOBAL_VARS")
endmacro(cmakeup_global_vars_recorder)


# print all cmakeup caching global vars
macro(cmakeup_global_vars_printer)
    foreach(item ${CMAKEUP_GLOBAL_VARS})
        unset(curr_golbal_var_val)
        set(curr_golbal_var_val "${${item}}")
        cmakeup_log("cmakeup_global_vars_printer" "${item}: ${curr_golbal_var_val}")
    endforeach(item)
endmacro(cmakeup_global_vars_printer)


# set cmakeup root path
macro(cmakeup_root_path_register cmakeup_root_path)
    unset(CMAKEUP_ROOT_PATH CACHE)
    set(CMAKEUP_ROOT_PATH "${cmakeup_root_path}" CACHE STRING "cmakeup scripts root path")
    cmakeup_global_vars_recorder(CMAKEUP_ROOT_PATH)
endmacro(cmakeup_root_path_register)


# One-step importing certain cmakeup package's cmake script. Before executing this, 
# `cmakeup_root_path_register` should be executed.
macro(cmakeup_pkg_cmake_importer org respository)
    unset(_target_cmake_module_root)
    set(_target_cmake_module_root ${CMAKEUP_ROOT_PATH}/pkg/${org}/${respository})
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${_target_cmake_module_root}")
    cmakeup_log("cmakeup_pkg_cmake_importer" "Append ${_target_cmake_module_root} to CMAKE_MODULE_PATH.")
endmacro(cmakeup_pkg_cmake_importer)


# Initializing cmakeup env, includes:
#     1. define and init some global vars.
#     2. build some paths.
macro(cmakeup_init cmakeup_dep_path cmakeup_github_proxy)
    cmakeup_log("cmakeup_init" "Setting global vars.")
    set_curr_path()

    # This is global var recorder
    unset(CMAKEUP_GLOBAL_VARS CACHE)
    set(CMAKEUP_GLOBAL_VARS CACHE LIST "cmakeup global vars")
    
    # Init cmakeup dependencies file root path
    unset(CMAKEUP_DEP_ROOT CACHE)
    set(CMAKEUP_DEP_ROOT "${CURR_PATH}/${cmakeup_dep_path}" CACHE STRING "cmakeup dep root path")
    cmakeup_global_vars_recorder(CMAKEUP_DEP_ROOT)
    execute_process(COMMAND mkdir -p ${CMAKEUP_DEP_ROOT})

    # Init cmakeup github proxy
    unset(CMAKEUP_GITHUB_PROXY CACHE)
    set(CMAKEUP_GITHUB_PROXY ${cmakeup_github_proxy} CACHE STRING "cmakeup github proxy")
    cmakeup_global_vars_recorder(CMAKEUP_GITHUB_PROXY)

    # Init cmakeup integrating package names.
    unset(CMAKEUP_INTEGRATE_PKG CACHE)
    set(CMAKEUP_INTEGRATE_PKG CACHE STRING "cmakeup integrating packages names.")
    cmakeup_global_vars_recorder(CMAKEUP_INTEGRATE_PKG)

    # Init cmakeup integrating package src paths.
    unset(CMAKEUP_INTEGRATE_PKG_ROOT CACHE)
    set(CMAKEUP_INTEGRATE_PKG_ROOT  CACHE STRING "cmakeup pkg src code root path.")
    cmakeup_global_vars_recorder(CMAKEUP_INTEGRATE_PKG_ROOT)

    # Init cmakeup integrated packages' header-file include path.
    unset(CMAKEUP_INCLUDE_PATH CACHE)
    set(CMAKEUP_INCLUDE_PATH  CACHE STRING "header files' include path managed by cmakeup.")
    cmakeup_global_vars_recorder(CMAKEUP_INCLUDE_PATH)

    # Init cmakeup integrated packages' static-lib path.
    unset(CMAKEUP_STATIC_LIB CACHE)
    set(CMAKEUP_STATIC_LIB  CACHE STRING "static lib files path managed by cmakeup.")
    cmakeup_global_vars_recorder(CMAKEUP_STATIC_LIB)

    # Init cmakeup integrated packages' dynamic(shared)-lib path.
    unset(CMAKEUP_SHARED_LIB CACHE)
    set(CMAKEUP_SHARED_LIB  CACHE STRING "shared/dynamic lib files path managed by cmakeup.")
    cmakeup_global_vars_recorder(CMAKEUP_SHARED_LIB)

    # Init cmakeup integrated packages' installation(root) path.
    unset(CMAKEUP_LIB_ROOT_DIR CACHE)
    set(CMAKEUP_LIB_ROOT_DIR CACHE STRING "lib installe dir. the 'install' means stardard install by `make insatll`")
    cmakeup_global_vars_recorder(CMAKEUP_LIB_ROOT_DIR)

    cmakeup_global_vars_printer()
    cmakeup_log("cmakeup_init" "Finished setting global vars.")
endmacro(cmakeup_init)


macro(cmakeup_github_pkg_set org respository branch github_proxy)
    cmakeup_log("cmakeup_github_pkg_set" "Setting package.")

    #set(BRANCH "master")
    #set(ORGANIZATION "oatpp")
    #set(RESPOSITORY "oatpp-mbedtls")
    #set(GIT_PROXY "https://ghproxy.com/")

    set(ORGANIZATION ${org})
    set(RESPOSITORY ${respository})
    set(BRANCH ${branch})

    if(${github_proxy} STREQUAL global)
        set(GITHUB_PROXY ${CMAKEUP_GITHUB_PROXY})
        cmakeup_log("cmakeup_github_pkg_set" "Sets GITHUB_PROXY with CMAKEUP_GITHUB_PROXY: ${GITHUB_PROXY}.")
    else()
        set(GITHUB_PROXY ${github_proxy})
        cmakeup_log("cmakeup_github_pkg_set" "Sets GITHUB_PROXY as: ${GITHUB_PROXY}.") 
    endif()

    set(PROJ ${ORGANIZATION}/${RESPOSITORY})
    set(TARGET_URL "${GITHUB_PROXY}https://github.com/${PROJ}/archive/refs/heads/${BRANCH}.zip")

    set(PKG_DEP_ROOT ${CMAKEUP_DEP_ROOT}/${ORGANIZATION}/${RESPOSITORY}/${BRANCH})
    execute_process(COMMAND mkdir -p ${PKG_DEP_ROOT})
    cmakeup_log("cmakeup_github_pkg_set" "PKG_DEP_ROOT: ${PKG_DEP_ROOT}")

    set(CMAKEUP_DEP_SRC_FOLDER ${RESPOSITORY}-${BRANCH})
    set(CMAKEUP_DEP_SRC_PATH ${PKG_DEP_ROOT}/${CMAKEUP_DEP_SRC_FOLDER})

    cmakeup_log("cmakeup_github_pkg_set" "Finished setting package: ${TARGET_URL}")
endmacro(cmakeup_github_pkg_set)


macro(cmakeup_git_pkg_get target_url pkg_dep_root branch src_dir_name)
    if(EXISTS "${pkg_dep_root}/${branch}.zip")
        cmakeup_log("cmakeup_git_pkg_get" "Pkg zip file ${pkg_dep_root}/${branch}.zip already exists.")
    else()
        execute_process(COMMAND wget ${target_url} WORKING_DIRECTORY ${pkg_dep_root})
        execute_process(COMMAND unzip ${BRANCH}.zip WORKING_DIRECTORY ${pkg_dep_root})
    endif()
endmacro(cmakeup_git_pkg_get)


macro(cmakeup_github_pkg_init org respository branch github_proxy)
    cmakeup_github_pkg_set(${org} ${respository} ${branch} ${github_proxy})
    cmakeup_git_pkg_get(${TARGET_URL} ${PKG_DEP_ROOT} ${BRANCH} ${CMAKEUP_DEP_SRC_FOLDER})
endmacro(cmakeup_github_pkg_init)


macro(cmakeup_cmake_build src_dir_path cmake_args make_args)
    unset(CMAKE_CMD)
    unset(MAKE_CMD)
    set(CMAKE_CMD "cmake ../ ${cmake_args}")
    set(MAKE_CMD "make ${make_args}")

    cmakeup_log("cmake_build" "params: ${src_dir_path} ${cmake_args} ${make_args}")
    cmakeup_log("cmake_build" "Executing cmake cmd: ${CMAKE_CMD}") 
    cmakeup_log("cmake_build" "Executing make cmd: ${MAKE_CMD}")
    cmakeup_log("cmake_build" "Working dir: ${src_dir_path}/build")

    execute_process(COMMAND mkdir -p ${src_dir_path}/build)
    
    # NOTE: CMAKE IS TOO STRANGE!!!
    # That the following line will not work, since `${cmake_args}` can not correctly 
    # passed to `cmake`.
    # But, the two lines after following two lines WORK!
    #
    # So the conclusion is, TRY OUT BEST TO USE LESS CMAKE ARGUMENTS/TRICKS!
    #
    #execute_process(COMMAND cmake ../ ${cmake_args} WORKING_DIRECTORY ${src_dir_path}/build)
    #execute_process(COMMAND make ${make_args} WORKING_DIRECTORY ${src_dir_path}/build) 
    execute_process(COMMAND bash -c "cd ${src_dir_path}/build && cmake ../ ${cmake_args}") 
    execute_process(COMMAND bash -c "cd ${src_dir_path}/build && make ${make_args}")  

    cmakeup_log("cmake_build" "Executing build at ${src_dir_path}/build.")
    cmakeup_log("cmake_build" "Finished execute cmake cmd: ${CMAKE_CMD}")
    cmakeup_log("cmake_build" "Finished execute make cmd: ${MAKE_CMD}")
endmacro(cmakeup_cmake_build)


# Register a packages related var(install/root path, header files' path, static/shared(dynamic lib path))
# to global variables.
macro(cmakeup_pkg_var_register var_type pkg_tag val)
    unset(var_name)
    set(var_name ${var_type}_${pkg_tag})
    cmakeup_log("cmakeup_pkg_var_register" "Registering global var ${var_name}")
    unset(${var_name} CACHE)
    # NOTE:
    # Using following `set(${var_name} ${val} CACHE LIST "")` will cause obscure error, 
    # since if `val` is a cmake `list`, than only first element will be used if not 
    # adds `${ARGN}` arg in `set` macro.
    #set(${var_name} ${val} CACHE LIST "")
    set(${var_name} ${val} ${ARGN} CACHE LIST "")
    cmakeup_global_vars_recorder(${var_name})
    list(APPEND ${var_type} ${var_name})
endmacro(cmakeup_pkg_var_register)

