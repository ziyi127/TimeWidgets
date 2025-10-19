cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

# Define the application target. To change its name, change BINARY_NAME in the
# top-level CMakeLists.txt, not the value here, or `flutter run` will no longer
# work.
#
# Any new source files that you add to the application should be added here.
add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "main.cpp"
  "system_tray_manager.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)

# Test executable
add_executable(test_system_tray
  "test_system_tray.cpp"
  "system_tray_manager.cpp"
)

# Apply the standard set of build settings to the test executable
apply_standard_settings(test_system_tray)

# Add UTF-8 encoding support to the test executable
target_compile_options(test_system_tray PRIVATE /utf-8)
target_compile_options(test_system_tray PRIVATE /source-charset:utf-8)
target_compile_options(test_system_tray PRIVATE /execution-charset:utf-8)

# Add preprocessor definitions for the test executable
target_compile_definitions(test_system_tray PRIVATE "NOMINMAX")

# Add dependency libraries and include directories for the test executable
target_link_libraries(test_system_tray PRIVATE flutter flutter_wrapper_app)
target_link_libraries(test_system_tray PRIVATE "dwmapi.lib")
target_include_directories(test_system_tray PRIVATE "${CMAKE_SOURCE_DIR}")

# Apply the standard set of build settings. This can be removed for applications
# that need different build settings.
apply_standard_settings(${BINARY_NAME})

# Add UTF-8 encoding support
target_compile_options(${BINARY_NAME} PRIVATE /utf-8)
target_compile_options(${BINARY_NAME} PRIVATE /source-charset:utf-8)
target_compile_options(${BINARY_NAME} PRIVATE /execution-charset:utf-8)

# Add preprocessor definitions for the build version.
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION=\"${FLUTTER_VERSION}\"")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}")

# Disable Windows macros that collide with C++ standard library functions.
target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

# Add dependency libraries and include directories. Add any application-specific
# dependencies here.
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE "dwmapi.lib")
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

# Run the Flutter tool portions of the build. This must not be removed.
add_dependencies(${BINARY_NAME} flutter_assemble)
