# file: oatpp-mbedtls_pkg.cmake
# date: 2021-04-21


cmake_minimum_required(VERSION 3.14)


macro(cmakeup_set_oatpp_mbedtls_vars)
    unset(_INSTALL_PATH)
    unset(_ORG)
    unset(_REPOSITORY)
    unset(_BRANCH)
    unset(_GITHUB_PROXY)
    unset(_POSTFIX)

    set(_INSTALL_PATH "./install")
    set(_ORG "oatpp")
    set(_REPOSITORY "oatpp-mbedtls")
    set(_BRANCH "master")
    set(_GITHUB_PROXY "global")
    set(_POSTFIX ${_ORG}_${_REPOSITORY}_${_BRANCH})
endmacro(cmakeup_set_oatpp_mbedtls_vars)


macro(cmakeup_get_oatpp_mbedtls_dep)
    cmakeup_pkg_cmake_importer("ARMmbed" "mbedtls")
    include(mbedtls_pkg)
    cmakeup_pkg_cmake_importer("oatpp" "oatpp")
    include(oatpp_pkg)
    
    #execute_process(COMMAND 
    #    bash -c "\
    #    mkdir -p ${CMAKEUP_DEP_ROOT}/cmake && cd ${CMAKEUP_DEP_ROOT}/cmake && \
    #    wget https://raw.githubusercontent.com/oatpp/example-websocket/master/cmake/module/Findmbedtls.cmake\
    #    ")
    
    #set(MBEDTLS_INCLUDE_DIR "${CMAKEUP_INCLUDE_PATH_ARMmbed_mbedtls_master}")
    #set(MBEDTLS_TLS_LIBRARY "${CMAKEUP_LIB_ROOT_DIR_ARMmbed_mbedtls_master}/lib/libmbedtls.a")
    #set(MBEDTLS_SSL_LIBRARY "${CMAKEUP_LIB_ROOT_DIR_ARMmbed_mbedtls_master}/lib/libmbedx509.a")
    #set(MBEDTLS_X509_LIBRARY "${CMAKEUP_LIB_ROOT_DIR_ARMmbed_mbedtls_master}/lib/libmbedx509.a")
    #set(MBEDTLS_CRYPTO_LIBRARY "${CMAKEUP_LIB_ROOT_DIR_ARMmbed_mbedtls_master}/lib/libmbedcrypto.a")
    #set(MBEDTLS_LIBRARIES 
    #    "${MBEDTLS_INCLUDE_DIR};${MBEDTLS_TLS_LIBRARY};${MBEDTLS_SSL_LIBRARY};${MBEDTLS_X509_LIBRARY};${MBEDTLS_CRYPTO_LIBRARY}")
    #set(MBEDTLS_VERSION "2.26.0")

    #set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKEUP_DEP_ROOT}/cmake")
    #include(FindPkgConfig)  
    #include(Findmbedtls) 
    #find_package(mbedtls 2.16.0 REQUIRED)
endmacro(cmakeup_get_oatpp_mbedtls_dep)


macro(cmakeup_build_oatpp_mbedtls)
    cmakeup_log("cmakeup_build_oatpp_mbedtls" "${_ORG} ${_REPOSITORY} ${_BRANCH}")
    cmakeup_log("cmakeup_build_oatpp_mbedtls" "Executing cmakeup_github_pkg_init.")
    cmakeup_github_pkg_init(${_ORG} ${_REPOSITORY} ${_BRANCH} ${_GITHUB_PROXY})
    cmakeup_cmake_build(${CMAKEUP_DEP_SRC_PATH} "\
        -DMBEDTLS_ROOT_DIR=${CMAKEUP_LIB_ROOT_DIR_ARMmbed_mbedtls_master} \
        -DOATPP_MODULES_LOCATION=CUSTOM -DOATPP_DIR_SRC=${CMAKEUP_INCLUDE_PATH_oatpp_oatpp_master} \
        -DOATPP_DIR_LIB=${CMAKEUP_INTEGRATE_PKG_ROOT_oatpp_oatpp_master}/build/src \
        -DOATPP_BUILD_TESTS=OFF\
        " 
        "-j8")
endmacro(cmakeup_build_oatpp_mbedtls)


macro(cmakeup_set_oatpp_mbedtls_lib_vars)
    unset(_src_root_path)
    unset(_include_path)
    unset(_static_lib_path)

    set(_src_root_path "${CMAKEUP_DEP_SRC_PATH}")
    set(_include_path "${CMAKEUP_DEP_SRC_PATH}/src")
    set(_include_path "${_include_path};${CMAKEUP_INCLUDE_PATH_ARMmbed_mbedtls_master}") 
    set(_static_lib_path "${CMAKEUP_DEP_SRC_PATH}/build/src/liboatpp-mbedtls.a")
    set(_static_lib_path "${_static_lib_path};${CMAKEUP_STATIC_LIB_ARMmbed_mbedtls_master}")
  
    cmakeup_pkg_var_register(CMAKEUP_INTEGRATE_PKG_ROOT ${_POSTFIX} ${_src_root_path}) 
    cmakeup_pkg_var_register(CMAKEUP_INCLUDE_PATH ${_POSTFIX} ${_include_path})
    cmakeup_pkg_var_register(CMAKEUP_STATIC_LIB ${_POSTFIX} ${_static_lib_path})
endmacro(cmakeup_set_oatpp_mbedtls_lib_vars)


macro(integrate_oatpp_mbedtls)
    cmakeup_get_oatpp_mbedtls_dep()
    cmakeup_set_oatpp_mbedtls_vars()
    cmakeup_build_oatpp_mbedtls()
    cmakeup_set_oatpp_mbedtls_lib_vars()
    include_directories(${CMAKEUP_INCLUDE_PATH_oatpp_oatpp-mbedtls_master})
endmacro(integrate_oatpp_mbedtls)


integrate_oatpp_mbedtls()
cmakeup_global_vars_printer()
