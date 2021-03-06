# file: libeigen_eigen_pkg.cmake  
# date: 2021-06-01


#cmake_minimum_required(VERSION ${CMAKEUP_MIN_CMAKE_VERSION})
cmake_minimum_required(VERSION 3.14)


macro(cmakeup_set_libeigen_eigen_vars branch install_dir github_host)
    unset(_INSTALL_PATH)
    unset(_ORG)
    unset(_REPOSITORY)
    unset(_BRANCH)
    unset(_GIT_HOST)
    unset(_POSTFIX)

    set(_INSTALL_PATH "./install")
    set(_ORG "libeigen")
    set(_REPOSITORY "eigen")
    set(_BRANCH ${branch})
    set(_GIT_HOST ${github_host})
    set(_POSTFIX ${_ORG}_${_REPOSITORY}_${_BRANCH})
endmacro(cmakeup_set_libeigen_eigen_vars)


macro(cmakeup_build_libeigen_eigen)
    cmakeup_log("cmakeup_build_${_POSTFIX}" "${_ORG} ${_REPOSITORY} ${_BRANCH}")
    cmakeup_log("cmakeup_build_${_POSTFIX}" "Executing cmakeup_github_pkg_init.")
    cmakeup_gitlab_pkg_init(${_ORG} ${_REPOSITORY} ${_BRANCH} ${_GIT_HOST})
    cmakeup_cmake_build(${CMAKEUP_DEP_SRC_PATH} "-DCMAKE_INSTALL_PREFIX=./install" "install")
endmacro(cmakeup_build_libeigen_eigen)


macro(cmakeup_set_libeigen_eigen_lib_vars)
    set(_src_root_path "${CMAKEUP_DEP_SRC_PATH}")
    set(_lib_install_path "${CMAKEUP_DEP_SRC_PATH}/build/${_INSTALL_PATH}") 
    set(_lib_include_path "${_lib_install_path}/include/eigen3")
    file(GLOB _static_lib_path CONFIGURE_DEPENDS "${_lib_install_path}/lib/*.a")
    
    cmakeup_pkg_var_register(CMAKEUP_INTEGRATE_PKG_ROOT ${_POSTFIX} ${_src_root_path}) 
    cmakeup_pkg_var_register(CMAKEUP_INSTALL_PATH ${_POSTFIX} ${_lib_install_path})
    cmakeup_pkg_var_register(CMAKEUP_INCLUDE_PATH ${_POSTFIX} ${_lib_include_path})
    #cmakeup_pkg_var_register(CMAKEUP_STATIC_LIB ${_POSTFIX} ${_static_lib_path};OpenSSL::SSL)
endmacro(cmakeup_set_libeigen_eigen_lib_vars)


macro(cmakeup_integrate_libeigen_eigen branch install_dir github_host)
    #find_package(OpenSSL REQUIRED) 

    cmakeup_set_libeigen_eigen_vars(${branch} ${install_dir} ${github_host})
    cmakeup_build_libeigen_eigen()
    cmakeup_set_libeigen_eigen_lib_vars()

    cmakeup_global_vars_printer()
    include_directories(${_lib_include_path})
endmacro(cmakeup_integrate_libeigen_eigen)

