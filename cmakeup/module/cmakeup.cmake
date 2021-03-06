# file: cmakeup.cmake
# date: 2021-04-18


# cmakeup log marco
macro(cmakeup_log func_name log_str)
    message(STATUS "[cmakeup.${func_name}] ${log_str}")
endmacro(cmakeup_log)


# cmakeup up log block splitter
macro(cmakeup_log_blocker block_name block_stage)
    unset(half_blocker_line)
    set(half_blocker_line "##############################")
    cmakeup_log("cmakeup_log_blocker" 
        "${half_blocker_line}  ${block_name} ${block_stage}  ${half_blocker_line}")
endmacro(cmakeup_log_blocker)


# cmakeup constant var setting
macro(cmakeup_set_const_vars)
    unset(CMAKEUP_MIN_CMAKE_VERSION CACHE)
    set(CMAKEUP_MIN_CMAKE_VERSION "3.14" CACHE STRING "cmakeup minimum cmake version")
    cmakeup_log("cmakeup_set_const_vars" "CMAKEUP_MIN_CMAKE_VERSION=${CMAKEUP_MIN_CMAKE_VERSION}")
    cmakeup_global_vars_recorder(CMAKEUP_MIN_CMAKE_VERSION)
endmacro(cmakeup_set_const_vars)


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
    cmakeup_log_blocker("cmakeup_global_vars_printer" "STARTING")
    foreach(item ${CMAKEUP_GLOBAL_VARS})
        unset(curr_golbal_var_val)
        set(curr_golbal_var_val "${${item}}")
        cmakeup_log("cmakeup_global_vars_printer" "${item}: ${curr_golbal_var_val}")
    endforeach(item)
    cmakeup_log_blocker("cmakeup_global_vars_printer" "FINISHED")
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
    include(${org}_${respository}_pkg)
    cmakeup_log("cmakeup_pkg_cmake_importer" "Included cmake script: ${org}_${respository}_pkg.cmake")
endmacro(cmakeup_pkg_cmake_importer)


# Initializing cmakeup env, includes:
#     1. define and init some global vars.
#     2. build some paths.
#
# cmakeup_dep_path: The path of cmakeup_hub, this MUST BE absolute path.
macro(cmakeup_init cmakeup_dep_path cmakeup_github_host)
    cmakeup_log_blocker("cmakeup_init" "STARTING")
    cmakeup_log("cmakeup_init" "Setting global vars.")

    # This is global var recorder, which will recored the name of every global vars
    # defined or redefined by cmakeup.
    unset(CMAKEUP_GLOBAL_VARS CACHE)
    set(CMAKEUP_GLOBAL_VARS CACHE LIST "cmakeup global vars")
    
    # Init
    set_curr_path()
    cmakeup_set_const_vars()

    # Recored any cmake-meaningufl global var's name defined or re-defined by cmakeup, 
    # it should be a subset of `CMAKEUP_GLOBAL_VARS`.
    unset(CMAKEUP_CMAKE_GLOBAL_VARS CACHE)
    set(CMAKEUP_CMAKE_GLOBAL_VARS CACHE LIST "cmakeup-defined cmake global vars.")
    cmakeup_global_vars_recorder(CMAKEUP_CMAKE_GLOBAL_VARS)

    # Init cmakeup dependencies file root path, all of the packages managed by cmakeup 
    # will be put under this path.
    unset(CMAKEUP_HUB_PATH CACHE)
    # Old Version:
    # At that time. `${cmakeup_dep_path}` is the relative path of cmakeup_hub under current directory.
    # set(CMAKEUP_HUB_PATH "${CURR_PATH}/${cmakeup_dep_path}" CACHE STRING "cmakeup dep root path")
    set(CMAKEUP_HUB_PATH "${cmakeup_dep_path}" CACHE STRING "cmakeup dep root path")
    cmakeup_global_vars_recorder(CMAKEUP_HUB_PATH)
    execute_process(COMMAND mkdir -p ${CMAKEUP_HUB_PATH})

    # Init cmakeup github host
    unset(CMAKEUP_GITHUB_HOST CACHE)
    set(CMAKEUP_GITHUB_HOST ${cmakeup_github_host} CACHE STRING "cmakeup github host")
    cmakeup_global_vars_recorder(CMAKEUP_GITHUB_HOST)

    # Init cmakeup gitlab host
    # TODO@202106011721: For now we do not needs customizing gitlab host.
    unset(CMAKEUP_GITLAB_HOST CACHE)
    set(CMAKEUP_GITLAB_HOST "https://gitlab.com" CACHE STRING "cmakeup gitlab host")
    cmakeup_global_vars_recorder(CMAKEUP_GITLAB_HOST)

    # Saving the name of the packages integrated by cmakeup.
    unset(CMAKEUP_INTEGRATE_PKG CACHE)
    set(CMAKEUP_INTEGRATE_PKG CACHE LIST "cmakeup integrating packages names.")
    cmakeup_global_vars_recorder(CMAKEUP_INTEGRATE_PKG)

    # Saving the name of vars that records certain packages' root path that contain its 
    # downloading compressed files, decompressed src files, include files, lib files, etc.
    unset(CMAKEUP_INTEGRATE_PKG_ROOT CACHE)
    set(CMAKEUP_INTEGRATE_PKG_ROOT CACHE LIST "cmakeup pkg src code root path.")
    cmakeup_global_vars_recorder(CMAKEUP_INTEGRATE_PKG_ROOT)

    # Saving the name of vars that records certain packages' include path of header-files.
    unset(CMAKEUP_INCLUDE_PATH CACHE)
    set(CMAKEUP_INCLUDE_PATH CACHE LIST "header files' include path managed by cmakeup.")
    cmakeup_global_vars_recorder(CMAKEUP_INCLUDE_PATH)

    # Saving the name of vars that records certain package's static lib after building. 
    unset(CMAKEUP_STATIC_LIB CACHE)
    set(CMAKEUP_STATIC_LIB CACHE LIST "static lib files path managed by cmakeup.")
    cmakeup_global_vars_recorder(CMAKEUP_STATIC_LIB)

    # Saving the name of vars that records certain package's dynamic(shared) lib after building.
    unset(CMAKEUP_SHARED_LIB CACHE)
    set(CMAKEUP_SHARED_LIB CACHE LIST "shared/dynamic lib files path managed by cmakeup.")
    cmakeup_global_vars_recorder(CMAKEUP_SHARED_LIB)

    # Saving the name of vars that records certain package's installation directory, it that 
    # directory will contain the include-path of header files and static/shared(dynamic) libs.
    # Besides, the 'install' means stardard install by `make install`. 
    unset(CMAKEUP_INSTALL_PATH CACHE)
    set(CMAKEUP_INSTALL_PATH CACHE LIST 
        "Saving the name of vars that records certain lib installation dir. the 'install' means stardard install by `make install`")
    cmakeup_global_vars_recorder(CMAKEUP_INSTALL_PATH)

    # Init cmakeup integrated packages' bin file path.
    # For instance, when integrate some packages such as protobuff, we will not only i
    # include header-files and static/dynamic lib, but also we need an protoc built bin 
    # to compile out `.proto` files.
    unset(CMAKEUP_BIN_PATH CACHE)
    set(CMAKEUP_BIN_PATH CACHE LIST "Saving the name of vars that records certain package's built bin path.")
    cmakeup_global_vars_recorder(CMAKEUP_BIN_PATH)

    cmakeup_global_vars_printer()
    cmakeup_log("cmakeup_init" "Finished setting global vars.")
    cmakeup_log_blocker("cmakeup_init" "FINISHED") 
endmacro(cmakeup_init)


macro(cmakeup_github_pkg_set org respository branch github_host)
    cmakeup_log("cmakeup_github_pkg_set" "Setting package.")

    set(ORGANIZATION ${org})
    set(RESPOSITORY ${respository})
    set(BRANCH ${branch})

    if(${github_host} STREQUAL global)
        set(GITHUB_HOST ${CMAKEUP_GITHUB_HOST})
        cmakeup_log("cmakeup_github_pkg_set" "Sets GITHUB_HOST with CMAKEUP_GITHUB_HOST: ${GITHUB_HOST}.")
    else()
        set(GITHUB_HOST ${github_host})
        cmakeup_log("cmakeup_github_pkg_set" "Sets GITHUB_HOST as: ${GITHUB_HOST}.") 
    endif()

    set(PROJ ${ORGANIZATION}/${RESPOSITORY})
    set(TARGET_URL "${GITHUB_HOST}/${PROJ}/archive/refs/heads/${BRANCH}.zip")

    set(PKG_DEP_ROOT ${CMAKEUP_HUB_PATH}/${ORGANIZATION}/${RESPOSITORY}/${BRANCH})
    execute_process(COMMAND mkdir -p ${PKG_DEP_ROOT})
    cmakeup_log("cmakeup_github_pkg_set" "PKG_DEP_ROOT: ${PKG_DEP_ROOT}")

    set(CMAKEUP_DEP_SRC_FOLDER ${RESPOSITORY}-${BRANCH})
    set(CMAKEUP_DEP_SRC_PATH ${PKG_DEP_ROOT}/${CMAKEUP_DEP_SRC_FOLDER})

    cmakeup_log("cmakeup_github_pkg_set" "Finished setting package: ${TARGET_URL}")
endmacro(cmakeup_github_pkg_set)


# TODO@202106011646:
# Here we have a `cmakeup_gitlab_pkg_set` and a `cmakeup_github_pkg_set`, 
# but they are almost same except url template, so maybe I can find an 
# elegant way to improve code-reuse at this point.
macro(cmakeup_gitlab_pkg_set org respository branch gitlab_host)
    cmakeup_log("cmakeup_gitlab_pkg_set" "Setting package.")

    set(ORGANIZATION ${org})
    set(RESPOSITORY ${respository})
    set(BRANCH ${branch})

    if(${gitlab_host} STREQUAL global)
        set(GITLAB_HOST ${CMAKEUP_GITLAB_HOST})
        cmakeup_log("cmakeup_gitlab_pkg_set" "Sets GITLAB_HOST with CMAKEUP_GITLAB_HOST: ${GITLAB_HOST}.")
    else()
        set(GITLAB_HOST ${gitlab_host})
        cmakeup_log("cmakeup_gitlab_pkg_set" "Sets GITLAB_HOST as: ${GITLAB_HOST}.") 
    endif()

    set(PROJ ${ORGANIZATION}/${RESPOSITORY})
    set(TARGET_URL "${GITLAB_HOST}/${PROJ}/-/archive/${BRANCH}/${RESPOSITORY}-${BRANCH}.zip")

    set(PKG_DEP_ROOT ${CMAKEUP_HUB_PATH}/${ORGANIZATION}/${RESPOSITORY}/${BRANCH})
    execute_process(COMMAND mkdir -p ${PKG_DEP_ROOT})
    cmakeup_log("cmakeup_gitlab_pkg_set" "PKG_DEP_ROOT: ${PKG_DEP_ROOT}")

    set(CMAKEUP_DEP_SRC_FOLDER ${RESPOSITORY}-${BRANCH})
    set(CMAKEUP_DEP_SRC_PATH ${PKG_DEP_ROOT}/${CMAKEUP_DEP_SRC_FOLDER})

    cmakeup_log("cmakeup_gitlab_pkg_set" "Finished setting package: ${TARGET_URL}")
endmacro(cmakeup_gitlab_pkg_set)



#macro(cmakeup_git_pkg_get_v0 target_url pkg_dep_root branch src_dir_name)
#    if(EXISTS "${pkg_dep_root}/${branch}.zip")
#        cmakeup_log("cmakeup_git_pkg_get" "Pkg zip file ${pkg_dep_root}/${branch}.zip already exists.")
#    else()
#        execute_process(COMMAND wget ${target_url} WORKING_DIRECTORY ${pkg_dep_root})
#        execute_process(COMMAND unzip ${BRANCH}.zip WORKING_DIRECTORY ${pkg_dep_root})
#    endif()
#endmacro(cmakeup_git_pkg_get_v0)


macro(cmakeup_git_pkg_get target_url pkg_dep_root branch src_dir_name)
    if(EXISTS "${pkg_dep_root}/_DOWNLOAD")
        cmakeup_log("cmakeup_git_pkg_get" "Package file under ${pkg_dep_root} already exists.")
    else()
        execute_process(COMMAND bash -c "cd ${pkg_dep_root} && wget ${target_url} --output-document ${BRANCH}.zip")
        execute_process(COMMAND unzip ${BRANCH}.zip WORKING_DIRECTORY ${pkg_dep_root})
        execute_process(COMMAND rm  ${BRANCH}.zip WORKING_DIRECTORY ${pkg_dep_root})
        # NOTE:
        # The reason of following line is: GITHUB's naming policy sucks! For example, downloading
        # zip file from gabime/spdlog's v1.x branch, the name of zip file is spdlog-v1.x.zip, and 
        # the decompressed folder named spdlog-1.x, where is the lossing 'v'??? but for master branch, 
        # the zip file called spdlog-master.zip, and the decompressed folder names spdlog-master.
        # So we needs manually unify the naming rule.   
        cmakeup_log("cmakeup_git_pkg_get" "Renaming code folder to ${src_dir_name}.")
        execute_process(COMMAND bash -c "cd ${pkg_dep_root} && mv ./* ./${src_dir_name}")
        execute_process(COMMAND touch ./_DOWNLOAD WORKING_DIRECTORY ${pkg_dep_root})
    endif()
endmacro(cmakeup_git_pkg_get)


macro(cmakeup_github_pkg_init org respository branch github_host)
    cmakeup_github_pkg_set(${org} ${respository} ${branch} ${github_host})
    cmakeup_git_pkg_get(${TARGET_URL} ${PKG_DEP_ROOT} ${BRANCH} ${CMAKEUP_DEP_SRC_FOLDER})
endmacro(cmakeup_github_pkg_init)


# TODO@202106011650: Ref to TODO@202106011646. 
macro(cmakeup_gitlab_pkg_init org respository branch gitlab_host)
    cmakeup_gitlab_pkg_set(${org} ${respository} ${branch} ${gitlab_host})
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

    # NOTE:
    # The reason not directly build `${src_dir_path}/build`, if `${src_dir_path}` 
    # does not exist, there must be sth wrong, so only build `./build` is helpful 
    # for debug.
    #execute_process(COMMAND mkdir -p ${src_dir_path}/build)
    execute_process(COMMAND bash -c "cd ${src_dir_path} && mkdir -p build")
    
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

