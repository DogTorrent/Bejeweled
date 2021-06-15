cmake_minimum_required(VERSION 3.14)

project(Bejeweled LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(REQUIRED_LIBS Core Quick QuickControls2 LinguistTools Multimedia MultimediaWidgets Sql)
set(REQUIRED_LIBS_QUALIFIED Qt5::Core Qt5::Quick Qt5::QuickControls2 Qt5::Multimedia Qt5::MultimediaWidgets Qt5::Sql)

find_package(QT NAMES Qt6 Qt5 COMPONENTS ${REQUIRED_LIBS} REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS ${REQUIRED_LIBS} REQUIRED)

# Add RC file
set(RC_FILE "app.rc")

# Add C++ source files
file(GLOB CPP_FILES "*.cpp" "*.h")

# Add QtQuick files
set(QML_FILES "qml.qrc")

# Add resource(image, audio, etc.) files
qt5_add_big_resources(RESOURCE_FILES "res.qrc")

# Add translation files
file(GLOB_RECURSE TS_FILES RELATIVE ${PROJECT_SOURCE_DIR} "*.ts")

# Set the output location of binary translation files based on the translation files
foreach(TS_FILE ${TS_FILES})
    get_filename_component(TS_FILE_DIR ${TS_FILE} DIRECTORY)
    set_source_files_properties(${TS_FILE} PROPERTIES OUTPUT_LOCATION ${TS_FILE_DIR})
endforeach()

# Auto update binary translation files
qt5_create_translation(QM_FILES ${PROJECT_SOURCE_DIR} ${TS_FILES})

set(PROJECT_SOURCES ${RC_FILE} ${QML_FILES} ${CPP_FILES} ${RESOURCE_FILES} ${QM_FILES})

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(${PROJECT_NAME} ${PROJECT_SOURCES})
else()
    add_executable(${PROJECT_NAME} ${PROJECT_SOURCES})
endif()

target_compile_definitions(${PROJECT_NAME}
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(${PROJECT_NAME} PRIVATE ${REQUIRED_LIBS_QUALIFIED})
