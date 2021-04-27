# file: atpp_oatpp-mbedtls_pkg.cmake
# date: 2021-04-27


#cmake_minimum_required(VERSION ${CMAKEUP_MIN_CMAKE_VERSION})
cmake_minimum_required(VERSION 3.14)


macro(cmakeup_set_oatpp_oatpp_mbedtls_vars branch install_dir github_host)
    unset(_INSTALL_PATH)
    unset(_ORG)
    unset(_REPOSITORY)
    unset(_BRANCH)
    unset(_GITHUB_HOST)
    unset(_POSTFIX)

    set(_INSTALL_PATH "./install")
    set(_ORG "oatpp")
    set(_REPOSITORY "oatpp-mbedtls")
    set(_BRANCH ${branch})
    set(_GITHUB_HOST ${github_host})
    set(_POSTFIX ${_ORG}_${_REPOSITORY}_${_BRANCH})
endmacro(cmakeup_set_oatpp_oatpp_mbedtls_vars)


macro(cmakeup_build_oatpp_oatpp_mbedtls_deps)
    # Integrate oatpp/oatpp
    cmakeup_pkg_cmake_importer("oatpp" "oatpp")
    cmakeup_integrate_oatpp_oatpp("master" "null" "global")
    # Integrate ARMmbed/mbedtls
    cmakeup_pkg_cmake_importer("ARMmbed" "mbedtls")
    cmakeup_integrate_ARMmbed_mbedtls("master" "./install" "global")
endmacro(cmakeup_build_oatpp_oatpp_mbedtls_deps)


macro(cmakeup_build_oatpp_oatpp_mbedtls)
    # This is the solution ref to https://github.com/oatpp/example-websocket/blob/master/client-binance.com/CMakeLists.txt.
    # if using this, we have to add `target_link_libraries(${__EXEC__} PUBLIC mbedtls::TLS mbedtls::X509 mbedtls::Crypto)`.
    # But this solution is not necessary, it just used to debug.
    #
    #execute_process(
    #    COMMAND wget https://raw.githubusercontent.com/oatpp/example-websocket/master/cmake/module/Findmbedtls.cmake 
    #    WORKING_DIRECTORY ${CMAKEUP_HUB_PATH})
    #include(FindPkgConfig)
    #list(APPEND CMAKE_MODULE_PATH ${CMAKEUP_HUB_PATH})
    #
    #unset(MBEDTLS_ROOT_DIR)
    #set(MBEDTLS_ROOT_DIR ${CMAKEUP_INSTALL_PATH_ARMmbed_mbedtls_master})
    #
    #find_package(mbedtls 2.16.0 REQUIRED)

    cmakeup_log("cmakeup_build_${_POSTFIX}" "${_ORG} ${_REPOSITORY} ${_BRANCH}")
    cmakeup_log("cmakeup_build_${_POSTFIX}" "Executing cmakeup_github_pkg_init.")
    cmakeup_github_pkg_init(${_ORG} ${_REPOSITORY} ${_BRANCH} ${_GITHUB_HOST})
    cmakeup_cmake_build(${CMAKEUP_DEP_SRC_PATH} 
        "-DMBEDTLS_ROOT_DIR=${CMAKEUP_INSTALL_PATH_ARMmbed_mbedtls_master} -D OATPP_MODULES_LOCATION=EXTERNAL"
        "-j8")
endmacro(cmakeup_build_oatpp_oatpp_mbedtls)


macro(cmakeup_set_oatpp_oatpp_mbedtls_lib_vars)
    set(_src_root_path "${CMAKEUP_DEP_SRC_PATH}")
    set(_include_path "${CMAKEUP_DEP_SRC_PATH}/src")
    set(_static_lib_path "${CMAKEUP_DEP_SRC_PATH}/build/src/liboatpp-mbedtls.a")
    
    cmakeup_pkg_var_register(CMAKEUP_INTEGRATE_PKG_ROOT ${_POSTFIX} ${_src_root_path}) 
    #cmakeup_pkg_var_register(CMAKEUP_INSTALL_PATH ${_POSTFIX} ${_lib_install_path})
    cmakeup_pkg_var_register(CMAKEUP_INCLUDE_PATH ${_POSTFIX} ${_include_path})
    cmakeup_pkg_var_register(CMAKEUP_STATIC_LIB ${_POSTFIX} ${_static_lib_path})
endmacro(cmakeup_set_oatpp_oatpp_mbedtls_lib_vars)


macro(cmakeup_integrate_oatpp_oatpp_mbedtls branch install_dir github_host)
    # `cmakeup_build_oatpp_oatpp_mbedtls_deps` must be executed first since some 
    # variabled needs unset.
    cmakeup_build_oatpp_oatpp_mbedtls_deps() 
    cmakeup_set_oatpp_oatpp_mbedtls_vars(${branch} ${install_dir} ${github_host})
    cmakeup_build_oatpp_oatpp_mbedtls()
    cmakeup_set_oatpp_oatpp_mbedtls_lib_vars()

    cmakeup_global_vars_printer()
    include_directories(${CMAKEUP_INCLUDE_PATH_oatpp_oatpp-mbedtls_master})
endmacro(cmakeup_integrate_oatpp_oatpp_mbedtls)

