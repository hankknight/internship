# Creature project third party module loader
# auto load cmake module startwith "Mod" and endwith "cmake", support loading offical 
# and custome cmake files.
# 
# This code provides the following function:
#  auto_load_extensions      - load cmake extension with given file list

# Parameters:
#   ARGN    - list a custome modules
# Usage:
#   auto_load_extensions(<variables_list>)
macro(auto_load_extensions)
    foreach(extension ${ARGN})
        include(${extension})
        message(STATUS "Load extension ${extension} success.")
    endforeach()
endmacro()


# Using cmake filesystem to glob all cmake modules
FILE(GLOB EXTENSIONS "${CMAKE_CURRENT_LIST_DIR}/Mod*.cmake")

# Automatically load or skip extension modules
if(DEFINED EXTENSIONS)
    message(STATUS "Find custom module in ${CMAKE_CURRENT_LIST_DIR}.")
    auto_load_extensions(${EXTENSIONS})
else()
    message(STATUS "Can't find any custome extension in ${CMAKE_CURRENT_LIST_DIR}.")
endif()
