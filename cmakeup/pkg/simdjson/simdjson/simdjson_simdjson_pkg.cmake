# file: simdjson_simdjson_pkg_cmake
# date: 2021-04-28


#cmake_minimum_required(VERSION ${CMAKEUP_MIN_CMAKE_VERSION})
cmake_minimum_required(VERSION 3.14)


macro(cmakeup_set_simdjson_simdjson_vars branch install_dir github_host)
    unset(_INSTALL_PATH)
    unset(_ORG)
    unset(_REPOSITORY)
    unset(_BRANCH)
    unset(_GITHUB_HOST)
    unset(_POSTFIX)

    set(_INSTALL_PATH "./install")
    set(_ORG "simdjson")
    set(_REPOSITORY "simdjson")
    set(_BRANCH ${branch})
    set(_GITHUB_HOST ${github_host})
    set(_POSTFIX ${_ORG}_${_REPOSITORY}_${_BRANCH})
endmacro(cmakeup_set_simdjson_simdjson_vars)


macro(cmakeup_build_simdjson_simdjson)
    cmakeup_log("cmakeup_build_${_POSTFIX}" "${_ORG} ${_REPOSITORY} ${_BRANCH}")
    cmakeup_log("cmakeup_build_${_POSTFIX}" "Executing cmakeup_github_pkg_init.")
    cmakeup_github_pkg_init(${_ORG} ${_REPOSITORY} ${_BRANCH} ${_GITHUB_HOST})
    cmakeup_cmake_build(${CMAKEUP_DEP_SRC_PATH} "" "-j8")
endmacro(cmakeup_build_simdjson_simdjson)


macro(cmakeup_set_simdjson_simdjson_lib_vars)
    set(_src_root_path "${CMAKEUP_DEP_SRC_PATH}")
    set(_include_path "${CMAKEUP_DEP_SRC_PATH}/include")
    set(_static_lib_path "${CMAKEUP_DEP_SRC_PATH}/build/libsimdjson.a")
    
    cmakeup_pkg_var_register(CMAKEUP_INTEGRATE_PKG_ROOT ${_POSTFIX} ${_src_root_path}) 
    #cmakeup_pkg_var_register(CMAKEUP_INSTALL_PATH ${_POSTFIX} ${_lib_install_path})
    cmakeup_pkg_var_register(CMAKEUP_INCLUDE_PATH ${_POSTFIX} ${_include_path})
    cmakeup_pkg_var_register(CMAKEUP_STATIC_LIB ${_POSTFIX} ${_static_lib_path})
endmacro(cmakeup_set_simdjson_simdjson_lib_vars)


macro(cmakeup_integrate_simdjson_simdjson branch install_dir github_host)
    cmakeup_set_simdjson_simdjson_vars(${branch} ${install_dir} ${github_host})
    cmakeup_build_simdjson_simdjson()
    cmakeup_set_simdjson_simdjson_lib_vars()

    cmakeup_global_vars_printer()
    include_directories(${CMAKEUP_INCLUDE_PATH_simdjson_simdjson_master})
endmacro(cmakeup_integrate_simdjson_simdjson)

