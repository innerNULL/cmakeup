# file: boostorg_boost_pkg.cmake  
# date: 2021-04-22


cmake_minimum_required(VERSION 3.14)


macro(cmakeup_set_boostorg_boost_vars tag install_dir github_proxy)
    unset(_INSTALL_PATH)
    unset(_ORG)
    unset(_REPOSITORY)
    unset(_TAG)
    unset(_GITHUB_PROXY)
    unset(_POSTFIX)

    set(_INSTALL_PATH ${install_dir})
    set(_ORG "boostorg")
    set(_REPOSITORY "boost")
    set(_TAG ${tag})
    set(_GITHUB_PROXY ${github_proxy})
    set(_POSTFIX ${_ORG}_${_REPOSITORY}_${_TAG})
endmacro(cmakeup_set_boostorg_boost_vars)


# URL example: https://dl.bintray.com/boostorg/release/1.76.0/source/boost_1_76_0.tar.bz2
# URL example: https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.bz2
macro(cmakeup_boostorg_boost_pkg_get)
    # Set a formatted tag, convert 1.76.0 to 1_76_0
    unset(BOOSTORG_BOOST_FORMATTED_TAG)
    execute_process(COMMAND bash -c "echo '${_TAG}' | sed 's/\\./_/g'" 
        OUTPUT_VARIABLE BOOSTORG_BOOST_FORMATTED_TAG)
    string(REPLACE "\n" "" BOOSTORG_BOOST_FORMATTED_TAG ${BOOSTORG_BOOST_FORMATTED_TAG})

    unset(CMAKEUP_INTEGRATE_PKG_ROOT_${_POSTFIX})
    cmakeup_pkg_var_register(CMAKEUP_INTEGRATE_PKG_ROOT ${_POSTFIX} 
        ${CMAKEUP_HUB_PATH}/${_ORG}/${_REPOSITORY}/${_TAG}/boost_${BOOSTORG_BOOST_FORMATTED_TAG})

    unset(CMKAEUP_BOOSTORG_BOOST_URL)
    set(CMKAEUP_BOOSTORG_BOOST_URL 
        "https://boostorg.jfrog.io/artifactory/main/release/${_TAG}/source/boost_${BOOSTORG_BOOST_FORMATTED_TAG}.tar.bz2")

    execute_process(COMMAND bash -c "mkdir -p ${CMAKEUP_INTEGRATE_PKG_ROOT_${_POSTFIX}}")

    if(EXISTS "${CMAKEUP_INTEGRATE_PKG_ROOT_${_POSTFIX}}/../_DOWNLOAD")
        cmakeup_log("cmakeup_boostorg_boost_pkg_get" 
            "Package file under ${CMAKEUP_INTEGRATE_PKG_ROOT_${_POSTFIX}}/.. already exists.")
    else()
        execute_process(COMMAND bash -c "\
            cd ${CMAKEUP_INTEGRATE_PKG_ROOT_${_POSTFIX}}/.. \
            && wget ${CMKAEUP_BOOSTORG_BOOST_URL} \
            && tar --bzip2 -xf ./boost_${BOOSTORG_BOOST_FORMATTED_TAG}.tar.bz2 \
            && touch _DOWNLOAD \
            && rm ./boost_${BOOSTORG_BOOST_FORMATTED_TAG}.tar.bz2\
        ")
    endif()

endmacro(cmakeup_boostorg_boost_pkg_get)


macro(cmakeup_build_boostorg_boost)
    cmakeup_log("cmakeup_build_boostorg_boost" 
        "Prepare installing boostorg/boost at ${CMAKEUP_INTEGRATE_PKG_ROOT_${_POSTFIX}}/${_INSTALL_PATH}.")
    execute_process(COMMAND bash -c "\
        cd ${CMAKEUP_INTEGRATE_PKG_ROOT_${_POSTFIX}} \
        && mkdir ${_INSTALL_PATH} \
        && ./bootstrap.sh --prefix=${_INSTALL_PATH} \
        && ./b2 install\
    ")
    cmakeup_log("cmakeup_build_boostorg_boost" 
        "Finished installing boostorg/boost at ${CMAKEUP_INTEGRATE_PKG_ROOT_${_POSTFIX}}/${_INSTALL_PATH}.")
endmacro(cmakeup_build_boostorg_boost)


macro(cmakeup_set_boostorg_boost_lib_vars)
    cmakeup_pkg_var_register("BOOST" "ROOT" "${CMAKEUP_INTEGRATE_PKG_ROOT_${_POSTFIX}}/${_INSTALL_PATH}")
    list(APPEND CMAKEUP_CMAKE_GLOBAL_VARS BOOST_ROOT)

    set(Boost_NO_SYSTEM_PATHS on CACHE BOOL "Do not search system for Boost")
    list(APPEND CMAKEUP_CMAKE_GLOBAL_VARS Boost_NO_SYSTEM_PATHS)
    list(APPEND CMAKEUP_GLOBAL_VARS Boost_NO_SYSTEM_PATHS)
endmacro(cmakeup_set_boostorg_boost_lib_vars)


macro(cmakeup_integrate_boostorg_boost tag install_dir github_proxy)
    cmakeup_log_blocker("cmakeup_integrate_boostorg_boost" "STARTING")
    cmakeup_set_boostorg_boost_vars(${tag} ${install_dir} ${github_proxy})
    cmakeup_boostorg_boost_pkg_get()
    cmakeup_build_boostorg_boost()
    cmakeup_set_boostorg_boost_lib_vars()

    cmakeup_global_vars_printer()
    #find_package(Boost REQUIRED regex date_time system filesystem thread graph program_options chrono)
    find_package(Boost REQUIRED 
        chrono context filesystem graph iostreams locale log program_options regex serialization thread timer wave)

    find_package(OpenSSL REQUIRED)

	if(Boost_FOUND)
        cmakeup_log("cmakeup_integrate_boostorg_boost" "Successfully found boostorg/boost lib with `find_package`.")
        cmakeup_log("cmakeup_integrate_boostorg_boost" 
            "`find_package` finds Boost_INCLUDE_DIRS: ${Boost_INCLUDE_DIRS}")
        cmakeup_log("cmakeup_integrate_boostorg_boost" 
            "`find_package` finds Boost_LIBRARIES: ${Boost_LIBRARIES}")

		include_directories(${Boost_INCLUDE_DIRS}) 
		#add_executable(progname file1.cxx file2.cxx) 
		#target_link_libraries(progname ${Boost_LIBRARIES})
	endif()

    cmakeup_log_blocker("cmakeup_integrate_boostorg_boost" "FINISHED")
endmacro(cmakeup_integrate_boostorg_boost)


