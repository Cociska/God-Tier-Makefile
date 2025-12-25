#!/bin/bash

# Function to add files to add_executable
update_cmake() {
    local cmakelists_file=$1

    # Find all .cpp and .hpp files, excluding certain directories
    files=$(find . -type f \( -name "*.c" -o -name "*.h" \) \
        ! -path "*/cmake-build-debug/*" \
        ! -path "*/CMakeFiles/*" \
        ! -path "*/.idea/*" \
        ! -path "*/cmake-ignore/*")

    # Convert file paths to a space-separated list
    files_list=""
    for file in $files; do
        files_list+="    $file\n"
    done

    # Check if add_executable exists
    if grep -q "add_executable" "$cmakelists_file"; then
        # Replace the contents of add_executable
        sed -zi "s|add_executable([^)]*)|add_executable(\${PROJECT_NAME}\n$files_list)|" "$cmakelists_file"
    else
        # Add add_executable if it doesn't exist
        echo -e "\nadd_executable(target_name\n$files_list)" >> "$cmakelists_file"
    fi
}

# Check if CMakeLists.txt exists
if [ -f "CMakeLists.txt" ]; then
    update_cmake "CMakeLists.txt"
else
    # Create a basic CMakeLists.txt if it doesn't exist
    cat <<EOL > CMakeLists.txt
cmake_minimum_required(VERSION 3.27.8)
project(day10 LANGUAGES CXX)

set(CMAKE_CXX_COMPILER "g++")
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_compile_options(-Wall -Wextra -Werror)

add_executable(exec
)
EOL
    update_cmake "CMakeLists.txt"
fi

# Print success message
echo "CMakeLists.txt has been updated with .cpp and .hpp files."
