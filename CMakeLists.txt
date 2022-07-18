cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

project(sampler)

# compile standard
set(CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# debug message
message(STATUS "**********************************************")
message(STATUS "sampler release version: 0.0.1")
message(STATUS "**********************************************")

# load custom cmake module
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindMods.cmake)

# specify libtorch package via project supply or user add
if(NOT DEFINED TORCH_RELEASE_C AND DEFINED TORCH_CUDA_C)
    set(TORCH_RELEASE_C "1.8.1")
elseif(DEFINED TORCH_RELEASE_C AND NOT DEFINED TORCH_CUDA_C)
    set(TORCH_CUDA_C "none")
elseif(NOT DEFINED TORCH_RELEASE_C AND NOT DEFINED TORCH_CUDA_C)
    set(TORCH_RELEASE_C "1.8.1")
    set(TORCH_CUDA_C "none")
endif()

# load torch asset
load_libtorch(${CMAKE_CURRENT_SOURCE_DIR} ${TORCH_RELEASE_C} ${TORCH_CUDA_C})

if(Torch_FOUND)
    # https://github.com/pytorch/pytorch/issues/38122
    set(${TORCH_USE_RTLD_GLOBAL} YES)
    find_library(TORCH_PYTHON_LIBRARY torch_python PATHS "${TORCH_INSTALL_PREFIX}/lib")
    message(STATUS "TORCH_PYTHON_LIBRARY: ${TORCH_PYTHON_LIBRARY}")
else()
    message(FATAL_ERROR "libtorch package load failed, please check ${CMAKE_CURRENT_SOURCE_DIR}/third_party or CMAKE_PREFIX_PATH.")
endif()

# core module
add_subdirectory(sampler)

# example
add_subdirectory(example)
