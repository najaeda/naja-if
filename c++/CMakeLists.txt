# SPDX-FileCopyrightText: 2025 The Naja authors <https://github.com/najaeda/naja/blob/main/AUTHORS>
#
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required(VERSION 3.21)

message(STATUS "CMake version: ${CMAKE_VERSION}")

project(naja-if)

set(CMAKE_CXX_STANDARD 20)
find_package(CapnProto REQUIRED)

add_library(sanitizers_config INTERFACE)
option(ENABLE_SANITIZERS "Enable sanitizers in compilation" OFF)
if(ENABLE_SANITIZERS)
  target_compile_options(sanitizers_config INTERFACE
    -fsanitize=address
    -fno-omit-frame-pointer
    #-fsanitize=thread
  )
  target_link_options(sanitizers_config INTERFACE
    -fsanitize=address
    #-fsanitize=thread
  )
endif(ENABLE_SANITIZERS)

set(CAPNPC_SRC_PREFIX "${PROJECT_SOURCE_DIR}/../schema" CACHE STRING "" FORCE)
set(CAPNPC_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})

capnp_generate_cpp(najaCommonSources najaCommonHeaders ${CAPNPC_SRC_PREFIX}/naja_common.capnp)
capnp_generate_cpp(najaNLInterfaceSources najaNLInterfaceHeaders ${CAPNPC_SRC_PREFIX}/naja_nl_interface.capnp)
capnp_generate_cpp(najaNLImplementationSources najaNLImplementationHeaders ${CAPNPC_SRC_PREFIX}/naja_nl_implementation.capnp)

add_library(naja_if STATIC
    ${najaCommonSources} ${najaNLInterfaceSources}
    ${najaNLImplementationSources}
)

target_link_libraries(naja_if PUBLIC CapnProto::capnp sanitizers_config)
target_include_directories(naja_if PUBLIC ${CMAKE_CURRENT_BINARY_DIR})

if(PROJECT_IS_TOP_LEVEL)
  include(FetchContent)
  FetchContent_Declare(
    googletest
    # Specify the commit you depend on and update it regularly.
    URL https://github.com/google/googletest/archive/52eb8108c5bdec04579160ae17225d66034bd723.zip
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  )
  # For Windows: Prevent overriding the parent project's compiler/linker settings
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  FetchContent_MakeAvailable(googletest)
  include(CTest)
  include(GoogleTest)
  enable_testing()
  add_subdirectory(test)
endif(PROJECT_IS_TOP_LEVEL)
