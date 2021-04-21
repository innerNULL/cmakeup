# file: oatpp-mbedtls_pkg.cmake
# date: 2021-04-21


cmake_minimum_required(VERSION 2.8.12)


macro(cmakeup_set_oatpp_vars)
    unset(_INSTALL_PATH)
    unset(_ORG)
    unset(_REPOSITORY)
    unset(_BRANCH)
    unset(_GITHUB_PROXY)
    unset(_POSTFIX)

    set(_INSTALL_PATH "./install")
    set(_ORG "oatpp")
    set(_REPOSITORY "oatpp")
    set(_BRANCH "master")
    set(_GITHUB_PROXY "global")
    set(_POSTFIX ${_ORG}_${_REPOSITORY}_${_BRANCH})
endmacro(cmakeup_set_oatpp_vars)


macro(cmakeup_build_oatpp)
    cmakeup_log("cmakeup_build_${_POSTFIX}" "${_ORG} ${_REPOSITORY} ${_BRANCH}")
    cmakeup_log("cmakeup_build_${_POSTFIX}" "Executing cmakeup_github_pkg_init.")
    cmakeup_github_pkg_init(${_ORG} ${_REPOSITORY} ${_BRANCH} ${_GITHUB_PROXY})
    cmakeup_cmake_build(${CMAKEUP_DEP_SRC_PATH} 
        #"-DOATPP_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=${CMAKEUP_LIB_ROOT_DIR_${_POSTFIX}}"
        "-DOATPP_BUILD_TESTS=OFF"
        "-j8")
endmacro(cmakeup_build_oatpp)


macro(cmakeup_set_oatpp_lib_vars)
    set(_include_path "${CMAKEUP_DEP_SRC_PATH}/src")
    set(_static_lib_path "${CMAKEUP_DEP_SRC_PATH}/build/src/liboatpp.a")
    
    #cmakeup_pkg_var_register(CMAKEUP_LIB_ROOT_DIR ${_POSTFIX} ${_lib_root_path})
    cmakeup_pkg_var_register(CMAKEUP_INCLUDE_PATH ${_POSTFIX} ${_include_path})
    cmakeup_pkg_var_register(CMAKEUP_STATIC_LIB ${_POSTFIX} ${_static_lib_path})
endmacro(cmakeup_set_mbedtls_lib_vars)


macro(integrate_oatpp)
    cmakeup_set_oatpp_vars()
    cmakeup_build_oatpp()
    cmakeup_set_oatpp_lib_vars()
    include_directories(${CMAKEUP_INCLUDE_PATH_oatpp_oatpp_master})
endmacro(integrate_oatpp)


integrate_oatpp()
cmakeup_global_vars_printer()
