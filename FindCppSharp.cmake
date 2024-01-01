# Look for an executable called sphinx-build
find_program(
  CPPSHARP_CLI_EXECUTABLE
  NAMES CppSharp.CLI
  DOC "Path to CppSharp.CLI executable")

include(FindPackageHandleStandardArgs)

# Handle standard arguments to find_package like REQUIRED and QUIET
find_package_handle_standard_args(
  CppSharp "Failed to find CppSharp.CLI executable" CPPSHARP_CLI_EXECUTABLE)
