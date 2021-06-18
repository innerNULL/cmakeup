# file: pytorch_pytorch_pkg.cmake  
# date: 2021-05-11


#cmake_minimum_required(VERSION ${CMAKEUP_MIN_CMAKE_VERSION})
cmake_minimum_required(VERSION 3.14)


macro(cmakeup_set_pytorch_pytorch_vars branch hardware)
    unset(_INSTALL_PATH)
    unset(_ORG)
    unset(_REPOSITORY)
    unset(_BRANCH)
    #unset(_GITHUB_HOST)
    unset(_POSTFIX)
    unset(_HARDWARE)

    set(_INSTALL_PATH "./install")
    set(_ORG "pytorch")
    set(_REPOSITORY "pytorch")
    set(_BRANCH ${branch})
    #set(_GITHUB_HOST ${github_host})
    set(_HARDWARE ${hardware})
    set(_POSTFIX ${_ORG}_${_REPOSITORY}_${_BRANCH}_${_HARDWARE})
endmacro(cmakeup_set_pytorch_pytorch_vars)


macro(cmakeup_build_pytorch_pytorch)
    cmakeup_github_pkg_set(${_ORG} ${_REPOSITORY} ${_BRANCH} "global")

    if (APPLE)
        set(_ZIP_URL "https://download.pytorch.org/libtorch/cpu/libtorch-macos-${_BRANCH}.zip")
    elseif (UNIX) 
        if ("${_HARDWARE}" STREQUAL "cpu")
            set(_ZIP_URL 
                "https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-${_BRANCH}%2Bcpu.zip")
        else()
            set(_ZIP_URL 
                "https://download.pytorch.org/libtorch/${_HARDWARE}/libtorch-cxx11-abi-shared-with-deps-${_BRANCH}%2B${_HARDWARE}.zip")
        endif()
    endif()
    
    #reset
    set(_src_root_path ${PKG_DEP_ROOT}/${_HARDWARE})
    execute_process(COMMAND bash -c "mkdir -p ${_src_root_path}")
    if (NOT EXISTS "${_src_root_path}/_DOWNLOAD")
        execute_process(COMMAND bash -c "cd ${_src_root_path} && wget ${_ZIP_URL}")
        execute_process(COMMAND bash -c "cd ${_src_root_path} && touch _DOWNLOAD")
    endif()
    execute_process(COMMAND bash -c "cd ${_src_root_path} && unzip *.zip")
endmacro(cmakeup_build_pytorch_pytorch)


macro(cmakeup_set_pytorch_pytorch_lib_vars)
    set(_src_root_path ${PKG_DEP_ROOT}/${_HARDWARE})
    set(_lib_install_path "${_src_root_path}/libtorch") 
    set(_lib_include_path "${_lib_install_path}/include")
    #file(GLOB _static_lib_path CONFIGURE_DEPENDS "${_lib_install_path}/lib/*.a")
    
    cmakeup_pkg_var_register(CMAKEUP_INTEGRATE_PKG_ROOT ${_POSTFIX} ${_src_root_path}) 
    cmakeup_pkg_var_register(CMAKEUP_INSTALL_PATH ${_POSTFIX} ${_lib_install_path})
    cmakeup_pkg_var_register(CMAKEUP_INCLUDE_PATH ${_POSTFIX} ${_lib_include_path})
endmacro(cmakeup_set_pytorch_pytorch_lib_vars)


macro(cmakeup_integrate_pytorch_pytorch branch install_dir github_host hardware)
    cmakeup_set_pytorch_pytorch_vars(${branch} ${hardware})
    cmakeup_build_pytorch_pytorch()
    cmakeup_set_pytorch_pytorch_lib_vars()

    find_package(Torch REQUIRED PATHS ${_lib_install_path})
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TORCH_CXX_FLAGS}")
    cmakeup_global_vars_printer()
    #include_directories(${_lib_include_path})
endmacro(cmakeup_integrate_pytorch_pytorch)

