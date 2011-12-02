
package = "lushmat"
version = "1.0-1"

source = {
   url = "lushmat-1.0-1.tgz"
}

description = {
   summary = "Provides an interface between LUSH's matrix format and Torch7's tensor.",
   detailed = [[
            A simple interface to LUSH's matrix format.
   ]],
   homepage = "",
   license = "MIT/X11" -- or whatever you like
}

dependencies = {
   "lua >= 5.1",
   "xlua"
}

build = {
   type = "cmake",

   cmake = [[
         cmake_minimum_required(VERSION 2.8)

         set (CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR})

         # infer path for Torch7
         string (REGEX REPLACE "(.*)lib/luarocks/rocks.*" "\\1" TORCH_PREFIX "${CMAKE_INSTALL_PREFIX}" )
         message (STATUS "Found Torch7, installed in: " ${TORCH_PREFIX})

         find_package (Torch REQUIRED)

         include_directories (${TORCH_INCLUDE_DIR})
         add_library (lushmat SHARED lushmat.c)
         link_directories (${TORCH_LIBRARY_DIR})
         target_link_libraries (lushmat ${TORCH_LIBRARIES})

         SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

         install_files(/lua lushmat.lua)
         install_targets(/lib lushmat)
   ]],

   variables = {
      CMAKE_INSTALL_PREFIX = "$(PREFIX)"
   }
}
