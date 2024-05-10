# CMakeList.txt : CMake project for GetSystemInfo, include source and define
# project specific logic here.
#

# Add source to this project's executable.
add_executable (GetSystemInfo "GetSystemInfo.cpp" "GetSystemInfo.h")

if (CMAKE_VERSION VERSION_GREATER 3.12)
  set_property(TARGET GetSystemInfo PROPERTY CXX_STANDARD 20)
endif()

# TODO: Add tests and install targets if needed.
