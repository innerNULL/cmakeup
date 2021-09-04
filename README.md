[TOC]

# cmakeup
## Introduction
A simple **CMAKE** based c++ pkg management module help **MAKEUP** c/cpp project easier. As its name, it's an cmake based project will make easy to integrade open-source c/c++ packages into your project.

The author is a naive and junior cpp coder. For now, **this project is still in development and in very early stage**. 


## Philosophy
* **Makes every project be self-constained，try best not pollute the whole system.**
* **Everything about the project should only be in the project.**
* **Supports elastic-enough way to integrate any version of any package into any project any times in an consistency style.**


## Features

## Why Use It
* I just want integrate certain lib/package into my this project, but not install too many things to my system, nor pollute my whole system!
* Multiple version of certain lib has been used by my project or my project's dependencies, I need an easy way to integrate each version without conflict happens.
* I hope integrated/built package should be only integrated/built once, no matter the package is integrated by my project or my project's dependency packages.
* I do not hope install anything else to get a cpp package manager.
* I needs an simple reading and understood cpp package-management tool that I can develope on to support my needs.

## Prerequisites
* Has cmake installed with version upper than 3.14
* Has basic knowledge with cmake and linux shell

## How To Use cmakeup in CMakeLists.txt
Just paste following codes block into your CMakeLists.txt
```cmake
execute_process(COMMAND bash -c "pwd" OUTPUT_VARIABLE CURR_DIR)
string(REPLACE "\n" "" CURR_DIR ${CURR_DIR}) 
message(STATUS "CURR_DIR: ${CURR_DIR}")

# Download cmakeup as pkg management.
if(EXISTS "${CURR_DIR}/main.zip")
    message(STATUS "cmakeup has been downloaded.")
else()
    execute_process(
        COMMAND bash -c "wget https://ghproxy.com/https://github.com/innerNULL/cmakeup/archive/refs/heads/main.zip"
        WORKING_DIRECTORY ${CURR_DIR})
    execute_process(
        COMMAND unzip main.zip WORKING_DIRECTORY ${CURR_DIR})
endif()
set(CMKAEUP_ROOT_PATH "${CURR_DIR}/cmakeup-main/cmakeup")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMKAEUP_ROOT_PATH}/module")
include(cmakeup)
cmakeup_init("${CURR_DIR}/_cmakeup_hub" "https://ghproxy.com/https://github.com")
cmakeup_root_path_register(${CMKAEUP_ROOT_PATH})
include(vcpkg_helpers)

integrate_vcpkg(
    "https://ghproxy.com/https://github.com/microsoft/vcpkg/archive/refs/heads/master.zip"  
    "${CURR_DIR}"
)
message(STATUS "All vcpkg pkg are installed under ${CMAKEUP_VCPKG_ROOT}/packages")
```
and then, if you want integrate an vcpkg pakcage, using sqlite3 as example, adds following codes in CMakeLists.txt: 
```
execute_process(COMMAND bash -c "${CMAKEUP_VCPKG_BIN} install sqlite3")
find_package(unofficial-sqlite3 CONFIG REQUIRED)
```
else if you want integrate an package with cmakeup supported modules, using abseil-cpp as example:
```
cmakeup_pkg_cmake_importer("abseil" "abseil-cpp")
cmakeup_integrate_abseil_abseil_cpp("master" "null" "global")
```

Note, in most case, when you using cmakeup-integration, you may use the integration module written by yourself, so the arguments may not always be same with above style.

## Notion
* **Cmakeup-Package**: 
In cmakeup, the **Package** represents the "project of the library", for example, an github repository of the lib is its cmakeup package.
* **Cmakeup-Lib**:
For cpp 14/17, for cmakeup, lib means the package's header files inlcude path, and its static/dynamic(shard) lib if it needs build.
* **Cmakeup-Integration**:
In cmakeup, the integration means the pipline of:
    * Downloading a **Package** and put it into an specific directory, depends on this package's organizarion/repository/tag(branch/version/etc)
    * Building the package if need, **register** the **Lib** info (such as include-path, static/shared-lib) to **Cmakeup-Global-Vars**.
    * Integrate the needing include-files and static/shared-lib to you developing project.
* **Cmakeup-Register**:
For cmakeup, we say, registering an package to cmakeup-global variables by **publish** its related vars (such as the static/shared-lib location, include path(header files location)) to **Cmakeup-Global-Vars**.
* **Cmakeup-Global-Vars**:
These global vars are **Cmake-Cache-Vars**, which names all start with **CMAKE** as prefix.

## Design
The design of cmakeup is simple and crude. It just puts and manages each package's each version source code into seperated-and-unique directories and building the package's src code to lib files in these path, and finally let cmakeup.

### Package Components
First of all, for one **cmakeup package**, all its components will under an specifice path under cmakeup root pkg path, depends on this package's **organization, project/repository, tag/branch/version** name.

* **Download File**: 
Such as the zip file downloaded from github or tar.gz file downloaded from certain wabsite.

* **Source File**:
We can get **Source File** unzip the **Download File**.

* **Build File**:
After building the **Source File**, we get the **Build File**, of cource some **header-only lib** does not need built, so in this case **Build File** only contain **Header Files**.
    * **Header Files(Include Path)**
    * **Lib Files**:
        * Static Lib Files
        * Shared(Dynamic) Lib Files
    * **Install Path**: 
    If build using `make install`, then there should be an install path which contains **Header Files(Include Path)** and **Lib Files**.
* **Status Flag File**:
    * **Downloaded Flag File**: _EXISTED
    * **TODO**: Convert **Downloaded Flag File** to _DOWNLOAD, Adds an **Built Flag File** as _BUILD

### Package Management
We can say, for cmakeup, the package(lib) management is **Directory-Based**. Any version/tag/branch of any organization's any project/repository will assigned an specific and unique path under **cmakeup root package management path**. 

Based on this simple but effective **path isolate strategy**, each package will be harmonious coexistence with out any conflict even some packages are just different version/tag/branch of same lib/repository. 

Besides of above, with corresponding **Cmakeup Global Vars** recorded by cmakeup, cmakeup can help you easily integrate what you want into your project without writting too many cmake codes.

### Cmakeup Global Vars
Cmakeup will holding some **Global Vars(cmake cache var)**. With these vars, cmakeup can let package info shared across the root project/package and the projects/packages depended by root project/package.

All **Global Vars(cmake cache var)** will held by using cmake's `set` macro with `CACHE` option, and all there vars could be found in the `CMakeCache.txt` under build path.

* **Cmakeup Common Global Vars**
There are common global var used to doing something such as variable and directory recorder. Most of there common global vars are defined at marco `cmakeup_init` and `cmakeup_set_const_vars`.
    * `CMAKEUP_GLOBAL_VARS`: 
    Recoreds all the name of **Cmakeup Common Global Vars**.
    * `CMAKEUP_MIN_CMAKE_VERSION`:
    Cmakeup minimum accept cmake version, invalid for now.
    * `CMAKEUP_CMAKE_GLOBAL_VARS`:
    Cmakeup registered certain cmake global variables.
    * `CMAKEUP_DEP_ROOT`:
    The root path that cmakeup will put everything in it, usually calls `_cmakeup_hub`.
    * `CMAKEUP_GITHUB_PROXY`:
    Github proxy, used as the github host prefix.
    * `CMAKEUP_INTEGRATE_PKG`:
    The names of the package integrated by cmakeup.
    * `CMAKEUP_INTEGRATE_PKG_ROOT`:
    The root path of each integrate package, actually this var is not usually use.
    * `CMAKEUP_INCLUDE_PATH`:
    A `LIST` recording the vars' name that each var recording one package's include-file/header-files' path.
    * `CMAKEUP_STATIC_LIB`:
    A `LIST` recording the vars' name that each var recording one package's static lib files' path.
    * `CMAKEUP_SHARED_LIB`:
    A `LIST` recording the vars' name that each var recording one package's dynamical/shared lib files' path.
    * `CMAKEUP_INSTALL_PATH`:
    A `LIST` recording the vars' name that each var recording one package's relative path that executing `make install`.
    * `CMAKEUP_BIN_PATH`:
    A `LIST` recording the vars' name that each var recording one package's compiled bin files' paths, using protobuffer as an example, `CMAKEUP_BIN_PATH` should save the var saving its protoc path.
    
* **Cmakeup Package Related Global Vars**
Each package integrated by cmakeup will assign several global vars with which we can call cmake macros such as `target_link_libraries`.
The naming rule is:
    * `CMAKEUP_INTEGRATE_PKG_ROOT_${ORGANIZATION}_${REPOSITORY}_${BRANCH}`:
    Each package's root path, which is also the root path of its source code, the following steps may build `build` folder relative to this path and doing compiling and install operations.

    * `CMAKEUP_INCLUDE_PATH_${ORGANIZATION}_${REPOSITORY}_${BRANCH}`: 
    Each package's header file path
    * `CMAKEUP_STATIC_LIB_${ORGANIZATION}_${REPOSITORY}_${BRANCH}`: 
    Each package's static lib file paths.
    * `CMAKEUP_SHARED_LIB_${ORGANIZATION}_${REPOSITORY}_${BRANCH}`: 
    Each package's dynamical/shared lib file paths.
    * `CMAKEUP_INSTALL_PATH_${ORGANIZATION}_${REPOSITORY}_${BRANCH}`: 
    Each package's **relative path** that execute `make install` command.
    * `CMAKEUP_BIN_PATH_${ORGANIZATION}_${REPOSITORY}_${BRANCH}`: 
    Saving package's compiled bin files' paths, using protobuffer as an example, this should save its protoc bin file path.


### Macro Naming Rule
* cmake macro not support "-" as legal name, so all the name contain "-" will be replaced with "_", for example, abseil-cpp should be abseil_cpp


### Cmakeup Integration Pipline
Here is the full pipline for **cmakeup's package integration and management**:
* **Initialization**:
At this step, cmkaeup will initialize some **Cmakeup-Global-Vars** and build the root directory to management depending packages, by default, it should be a directory called '**_cmakeup_hub**' under your 'build' directory.
* **Downloading**
For each package, cmakeup will download its source code, from github/gitlab, in some case, cmakeup can also download lib files directly, the root-path of each package's source code will saved at `CMAKEUP_INTEGRATE_PKG_ROOT_${ORGANIZATION}_${REPOSITORY}_${BRANCH}`, and `CMAKEUP_INTEGRATE_PKG_ROOT_${ORGANIZATION}_${REPOSITORY}_${BRANCH}` will be appended in `CMAKEUP_INTEGRATE_PKG_ROOT`.
* **Building and Installing**
The classical process is make an `build` or `cmakeup_build` path relative/under `CMAKEUP_INTEGRATE_PKG_ROOT_${ORGANIZATION}_${REPOSITORY}_${BRANCH}` and execute `cmakeup ../` and `make install`, register some path variables into the global vars mentioned in **Cmakeup Package Related Global Vars**.
* **Integration**
Just call some cmake macros such as `target_link_libraries` and `include_directories` to each package's header-files paths and static/shared lib files paths.

## vcpkg Integration
TODO, For now ref to [examples/vcpkg_integration](https://github.com/innerNULL/cmakeup/tree/main/examples/vcpkg_integration)

## Cmakeup Architecture
### Directory Architecture
TODO

## How to Integrate Unsuportted Package
TODO

## Classical Usage
TODO

## Supported Packages
* **[ARMmbed/mbedtls](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/ARMmbed/mbedtls)**
* **[Tencent/rapidjson](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/Tencent/rapidjson)**
* **[abseil/abseil-cpp](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/abseil/abseil-cpp)**
* **[boostorg/boost](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/boostorg/boost)**
* **[facebookresearch/fastText](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/facebookresearch/fastText)**
* **[gabime/spdlog](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/gabime/spdlog)**
* **[libeigen/eigen](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/libeigen/eigen)**
* **[nlohmann/json](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/nlohmann/json)**
* **[oatpp/oatpp-mbedtls](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/oatpp/oatpp-mbedtls)**
* **[oatpp/oatpp-websocket](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/oatpp/oatpp-websocket)**
* **[oatpp/oatpp](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/oatpp/oatpp)**
* **[whoshuu/cpr](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/whoshuu/cpr)**
* **[yhirose/cpp-httplib](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/yhirose/cpp-httplib)**
* **[pytorch/pytorch](https://github.com/innerNULL/cmakeup/tree/main/cmakeup/pkg/pytorch/pytorch)**
