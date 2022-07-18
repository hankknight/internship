# Download libtorch with specify release version and device
# 
# This extension is download libtorch corresponding to the user given
# release version device provides.
# 
# This code provides the following function:
#  load_libtorch        - load libtorch if not exist download it
#  fetch_libtorch       - download libtorch
#  init_libtorch_config - set default libtorch cmake variable(#fixed)

# Parameters:
#   torch_dir     - libtorch directory
#   release_ver   - libtorch release version,such as 1.9.1, etc
#   device_ver    - libtorch device version,such as none, cu102, etc
# Usage:
#   fetch_libtorch(<directory_string> <version_string> <cuda_string>)
function(fetch_libtorch torch_dir release_ver device_ver)
    # debug message
    message(STATUS "${torch_dir} is not existed,start downloading")

    # release version check
    if(${release_ver} VERSION_LESS "1.8.1")
        message(FATAL_ERROR "Libtorch version must equal or higher than 1.8.1,but got ${version} instead.")
    else()
        set(LIBTORCH_VER ${release_ver})
    endif()

    # device version check
    if(${device_ver} STREQUAL "none")
        set(LIBTORCH_DEVICE "cpu")
    elseif(${device_ver} STREQUAL "10.2")
        set(LIBTORCH_DEVICE "cu102")
    elseif(${device_ver} STREQUAL "11.1")
        set(LIBTORCH_DEVICE "cu111")
    elseif(${device_ver} STREQUAL "11.3")
        set(LIBTORCH_DEVICE "cu113")
    else()
        message(FATAL_ERROR "Invalid device version,only accept 10.2, 11.1, 11.3 or none!")
    endif()

    # concat download url via operation system,ignore MacOS.
    # `CMAKE_SYSTEM_NAME` is a builtin cmake variable
    if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
        # check torch CXX11_ABI enable status
        execute_process(
            COMMAND python -c "import torch;print(torch._C._GLIBCXX_USE_CXX11_ABI)"
            OUTPUT_VARIABLE _TORCH_CXX_ABI
            ERROR_QUIET
        )

        # use regex to match pytorch abi support
        if(_TORCH_CXX_ABI MATCHES "[T|t]rue")
            set(LIBTORCH_URL 
                "https://download.pytorch.org/libtorch/${LIBTORCH_DEVICE}/libtorch-cxx11-abi-shared-with-deps-${LIBTORCH_VER}%2B${LIBTORCH_DEVICE}.zip")
        else()
            set(LIBTORCH_URL 
                "https://download.pytorch.org/libtorch/${LIBTORCH_DEVICE}/libtorch-shared-with-deps-${LIBTORCH_VER}%2B${LIBTORCH_DEVICE}.zip")
        endif()

    elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
        set(LIBTORCH_URL 
            "https://download.pytorch.org/libtorch/${LIBTORCH_DEVICE}/libtorch-win-shared-with-deps-${LIBTORCH_VER}%2B${LIBTORCH_DEVICE}.zip")
    else()
        message(FATAL_ERROR "Unsupport operation system ${CMAKE_SYSTEM_NAME}(expected 'Windows' or 'Linux').")
    endif()

    # debug message
    message(STATUS "Downloading libtorch ${LIBTORCH_VER} on ${CMAKE_SYSTEM_NAME},fetch url is: ${LIBTORCH_URL}")

    # Download libtorch to third patry folder
    # more detail check:
    # https://cmake.org/cmake/help/latest/module/ExternalProject.html#id3
    include(FetchContent)
    FetchContent_Declare(
        libtorch
        PREFIX libtorch
        DOWNLOAD_DIR ${torch_dir}
        SOURCE_DIR ${torch_dir}
        URL ${LIBTORCH_URL}
    )
    FetchContent_MakeAvailable(libtorch)

endfunction()

# Parameters:
#   root_dir      - top directory of current project
#   release_ver   - libtorch release version,such as 1.9.1, etc
#   device_ver    - libtorch device version,such as cpu, cu102, etc
# Usage:
#   load_libtorch(<directory_string> <version_string> <cuda_string>)
macro(load_libtorch root_dir release_ver device_ver)
    # libtorch dir
    set(LIBTORCH_DIR "${root_dir}/third_party/libtorch")
    # debug message
    message(STATUS "Searching ${LIBTORCH_DIR} directory to load libtorch.")

    if(EXISTS ${LIBTORCH_DIR})
        # debug message
        message(STATUS "${LIBTORCH_DIR} is already existed,skip downloading.")
    else()
        fetch_libtorch(${LIBTORCH_DIR} ${release_ver} ${device_ver})
    endif()
    # find torch ignore error if not found
    find_package(Torch QUIET PATHS ${LIBTORCH_DIR})
    # avoid conflict with googletest(most important)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${TORCH_CXX_FLAGS}")

    # debug message
    message(STATUS "** Load libtorch - done. **")

    # clear cache
    unset(LIBTORCH_DIR)

endmacro()
