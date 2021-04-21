# file: mbedtls_pkg.cmake
# date: 2021-04-18


cmake_minimum_required(VERSION 2.8.12)


macro(cmakeup_set_mbedtls_vars)
    unset(_INSTALL_PATH)
    unset(_ORG)
    unset(_REPOSITORY)
    unset(_BRANCH)
    unset(_GITHUB_PROXY)
    unset(_POSTFIX)

    set(_INSTALL_PATH "./install")
    set(_ORG "ARMmbed")
    set(_REPOSITORY "mbedtls")
    set(_BRANCH "master")
    set(_GITHUB_PROXY "global")
    set(_POSTFIX ${_ORG}_${_REPOSITORY}_${_BRANCH})
endmacro(cmakeup_set_mbedtls_vars)


macro(cmakeup_build_mbedtls)
    #cmakeup_init("./_cmakeup_dep" "https://ghproxy.com/")
    cmakeup_github_pkg_init(${_ORG} ${_REPOSITORY} ${_BRANCH} ${_GITHUB_PROXY})
    cmakeup_cmake_build(${CMAKEUP_DEP_SRC_PATH} 
        "-DCMAKE_INSTALL_PREFIX:PATH=${_INSTALL_PATH}" 
        "install")

endmacro(cmakeup_build_mbedtls)


macro(cmakeup_set_mbedtls_lib_vars)
    set(_lib_root_path "${CMAKEUP_DEP_SRC_PATH}/build/${_INSTALL_PATH}")
    
    set(_include_path ${_lib_root_path}/include)
    
    set(_static_lib_path "${_lib_root_path}/lib/libmbedcrypto.a")
    set(_static_lib_path "${_static_lib_path};${_lib_root_path}/lib/libmbedtls.a")
    set(_static_lib_path "${_static_lib_path};${_lib_root_path}/lib/libmbedx509.a")
    
    cmakeup_pkg_var_register(CMAKEUP_LIB_ROOT_DIR ${_POSTFIX} ${_lib_root_path})
    cmakeup_pkg_var_register(CMAKEUP_INCLUDE_PATH ${_POSTFIX} ${_include_path})
    cmakeup_pkg_var_register(CMAKEUP_STATIC_LIB ${_POSTFIX} ${_static_lib_path})
endmacro(cmakeup_set_mbedtls_lib_vars)


macro(integrate_mbedtls)
    cmakeup_set_mbedtls_vars()
    cmakeup_build_mbedtls()
    cmakeup_set_mbedtls_lib_vars()
    include_directories(${CMAKEUP_INCLUDE_PATH_ARMmbed_mbedtls_master})
endmacro(integrate_mbedtls)


integrate_mbedtls()
cmakeup_global_vars_printer()
