cmake_minimum_required(VERSION 3.0)
set(CMAKE_CXX_COMPILER g++-5)
set(CMAKE_CXX_STANDARD 11)

project(ibex-geometry)
set(PACKAGE_VERSION "1.0.dev0")

# build type
IF(NOT CMAKE_BUILD_TYPE)
	#SET(CMAKE_BUILD_TYPE "Release")
	SET(CMAKE_BUILD_TYPE "DEBUG")
	#SET(CMAKE_BUILD_TYPE "RELWITHDEBINFO")
	#SET(CMAKE_BUILD_TYPE "MINSIZEREL")
ENDIF()

# option declaration
option(BUILD_TESTS "Build tests" OFF)
option(WITH_PYTHON "Build python module" OFF)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMakeModules/)



if(NOT WIN32)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC"  )
	set(IbexLib_USE_STATIC 1)
endif()

#FIND_PACKAGE(IbexLib)
#if(IBEX_FOUND)
#  INCLUDE_DIRECTORIES(${IBEX_INCLUDE_DIRS})
#  SET(LIBS ${LIBS} ${IBEX_LIBRARIES} )
#else()
#  MESSAGE(WARNING "Unable to find IbexLib. Maybe you need to set IBEX_ROOT ${IBEX_ROOT}")
#  MESSAGE(WARNING "If ibex is not installer run : \n\t sh travis_script/install_ibexlib.sh /path/to/your/install/dir")
#  #MESSAGE(FATAL_ERROR "where ")
#endif()


get_filename_component(TUBEX_ROOT "~/tubex-lib/" ABSOLUTE) # used for find_packages modules
list(APPEND CMAKE_MODULE_PATH "${TUBEX_ROOT}/cmake/modules") # location of find_package modules
find_package(TubexLib REQUIRED)
find_package(IbexLib REQUIRED)
include_directories("${TUBEX_INCLUDE_DIR}" "${IBEX_INCLUDE_DIR}" "/usr/local/include/ibex/" "/usr/local/include/ibex/3rd/")

set(HEADERS_DIR ${CMAKE_CURRENT_BINARY_DIR}/include)
file(MAKE_DIRECTORY ${HEADERS_DIR})
include_directories(${HEADERS_DIR})
add_subdirectory(src)




if (BUILD_TESTS)
	ENABLE_TESTING()
	include( CTest )
	add_subdirectory(tests)
endif(BUILD_TESTS)

if (WITH_PYTHON)
	add_subdirectory(pybind11)
	add_subdirectory(python)
endif()

#
# if (BUILD_EXAMPLE)
# 	add_subdirectory(examples)
# endif(BUILD_EXAMPLE)


#########################################################################
### Uninstall ###
#########################################################################
configure_file("${CMAKE_HOME_DIRECTORY}/CMakeModules/cmake_uninstall.cmake.in" "cmake_uninstall.cmake" IMMEDIATE @ONLY)
add_custom_target(uninstall "${CMAKE_COMMAND}" -P "cmake_uninstall.cmake")
