# file: oatpp_oatpp_pkg.cmake
# date: 2021-04-21


#cmake_minimum_required(VERSION ${CMAKEUP_MIN_CMAKE_VERSION})
cmake_minimum_required(VERSION 3.14)


macro(cmakeup_set_oatpp_oatpp_vars branch install_dir github_proxy)
    unset(_INSTALL_PATH)
    unset(_ORG)
    unset(_REPOSITORY)
    unset(_BRANCH)
    unset(_GITHUB_PROXY)
    unset(_POSTFIX)

    set(_INSTALL_PATH "./install")
    set(_ORG "oatpp")
    set(_REPOSITORY "oatpp")
    set(_BRANCH ${branch})
    set(_GITHUB_PROXY ${github_proxy})
    set(_POSTFIX ${_ORG}_${_REPOSITORY}_${_BRANCH})
endmacro(cmakeup_set_oatpp_oatpp_vars)


macro(cmakeup_build_oatpp_oatpp)
    cmakeup_log("cmakeup_build_${_POSTFIX}" "${_ORG} ${_REPOSITORY} ${_BRANCH}")
    cmakeup_log("cmakeup_build_${_POSTFIX}" "Executing cmakeup_github_pkg_init.")
    cmakeup_github_pkg_init(${_ORG} ${_REPOSITORY} ${_BRANCH} ${_GITHUB_PROXY})
    cmakeup_cmake_build(${CMAKEUP_DEP_SRC_PATH} 
        #"-DOATPP_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=${CMAKEUP_LIB_ROOT_DIR_${_POSTFIX}}"
        "-DOATPP_BUILD_TESTS=OFF"
        "-j8")
endmacro(cmakeup_build_oatpp_oatpp)


macro(cmakeup_set_oatpp_oatpp_lib_vars)
    set(_src_root_path "${CMAKEUP_DEP_SRC_PATH}")
    set(_include_path "${CMAKEUP_DEP_SRC_PATH}/src")
    set(_static_lib_path "${CMAKEUP_DEP_SRC_PATH}/build/src/liboatpp.a")
    
    cmakeup_pkg_var_register(CMAKEUP_INTEGRATE_PKG_ROOT ${_POSTFIX} ${_src_root_path}) 
    #cmakeup_pkg_var_register(CMAKEUP_LIB_ROOT_DIR ${_POSTFIX} ${_lib_root_path})
    cmakeup_pkg_var_register(CMAKEUP_INCLUDE_PATH ${_POSTFIX} ${_include_path})
    cmakeup_pkg_var_register(CMAKEUP_STATIC_LIB ${_POSTFIX} ${_static_lib_path})
endmacro(cmakeup_set_oatpp_oatpp_lib_vars)


macro(cmakeup_integrate_oatpp_oatpp branch install_dir github_proxy)
    cmakeup_set_oatpp_oatpp_vars(${branch} ${install_dir} ${github_proxy})
    cmakeup_build_oatpp_oatpp()
    cmakeup_set_oatpp_oatpp_lib_vars()

    cmakeup_global_vars_printer()
    include_directories(${CMAKEUP_INCLUDE_PATH_oatpp_oatpp_master})
endmacro(cmakeup_integrate_oatpp_oatpp)

