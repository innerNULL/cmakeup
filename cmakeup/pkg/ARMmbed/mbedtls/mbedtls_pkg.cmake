# file: mbedtls_pkg.cmake
# date: 2021-04-18


cmake_minimum_required(VERSION 2.8.12)


set(MBEDTLS_INSTALL_PATH "./install")


macro(integrate_mbedtls)
    set_var()

    init_github_pkg("ARMmbed" "mbedtls" "master" "https://ghproxy.com/")
    cmake_build(${CMAKEUP_DEP_SRC_PATH} 
        "-DCMAKE_INSTALL_PREFIX:PATH=${MBEDTLS_INSTALL_PATH}" 
        "install")

    set(CMAKEUP_MBEDTLS_ROOT_DIR 
        "${CMAKEUP_DEP_SRC_PATH}/build/${MBEDTLS_INSTALL_PATH}" 
        CACHE STRING "mbedtls install path.")

    cmakeup_log("integrate_mbedtls" 
        "Finished integrate mbedtls, sets an cmake global var CMAKEUP_MBEDTLS_ROOT_DIR: ${CMAKEUP_MBEDTLS_ROOT_DIR}")
endmacro(integrate_mbedtls)


integrate_mbedtls()

