cmake_minimum_required(VERSION 3.4.1)

project(opencv_wrapper CXX)

add_library(opencv_wrapper SHARED
        src/main/cpp/opencv_wrapper.cpp
)
set(OpenCV_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../sdk/native/jni)
set(OPENCV_COMPONENTS "opencv_core" "opencv_objdetect" CACHE STRING "")
find_package(OpenCV REQUIRED COMPONENTS ${OPENCV_COMPONENTS})

target_include_directories(opencv_wrapper PRIVATE
        ${OpenCV_INCLUDE_DIRS}
        ${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp
)
target_link_libraries(opencv_wrapper ${OpenCV_LIBS})