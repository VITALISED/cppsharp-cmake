function(add_cppsharp_target target_name target_to_bind source output_namespace
         definitions
)
    # Define the output file in the CMake binary output directory
    set(output_file "${CMAKE_CURRENT_BINARY_DIR}/${target_name}_output")

    get_target_property(
        target_include_dirs ${target_to_bind} INCLUDE_DIRECTORIES
    )

    # Get the linked libraries from the target
    get_target_property(linked_libraries ${target_to_bind} LINK_LIBRARIES)

    # Initialize an empty list to hold all include directories
    set(all_include_dirs ${target_include_dirs})

    # Iterate over the linked libraries
    foreach(lib ${linked_libraries})
        # Get the INTERFACE_INCLUDE_DIRECTORIES property from the library
        get_target_property(
            lib_include_dirs ${lib} INTERFACE_INCLUDE_DIRECTORIES
        )

        # Append the library's include directories to the list
        list(APPEND all_include_dirs ${lib_include_dirs})
    endforeach()

    # Initialize an empty string to hold the include flags
    set(TARGET_INCLUDES "")

    # Iterate over the include directories
    foreach(item ${all_include_dirs})
        # Prepend each directory with -I and append it to the include flags
        if(NOT item MATCHES "(SYSTEM)")
            string(APPEND TARGET_INCLUDES " -I\"${item}\"")
        endif()
    endforeach()

    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(CPPSHARP_ARCH_STR "x64")
    elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(CPPSHARP_ARCH_STR "x86")
    endif()

    file(GLOB_RECURSE SKYSCRAPER_HEADERS ${CMAKE_CURRENT_LIST_DIR}/ "*.h"
         "*.inl"
    )

    set(THE_HEADERS "")
    foreach(item ${SKYSCRAPER_HEADERS})
        # message(STATUS "Adding header file: ${item}")
        string(APPEND THE_HEADERS " ${item}")
    endforeach()

    # Define the command to run CppSharp
    add_custom_command(
        OUTPUT ${output_file}
        COMMAND
            ${CPPSHARP_CLI_EXECUTABLE} ARGS ${source} ${TARGET_INCLUDES} -o
            ${output_file} --rtti --exceptions -a ${CPPSHARP_ARCH_STR}
            ${definitions} -on ${output_namespace}
        DEPENDS ${target_to_bind}
        COMMENT "Generating C# bindings with CppSharp"
    )

    add_custom_target(${target_name}_gen DEPENDS ${output_file})
    add_library(${target_name} STATIC ${source})
    add_dependencies(${target_name} ${target_name}_gen)
endfunction()
