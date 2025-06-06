#include "opencv_wrapper.h"

#include <vector>
#include <opencv2/opencv.hpp>
#include <opencv2/objdetect/aruco_detector.hpp>

#ifdef __cplusplus
extern "C" {
#endif

#define EXPORT __attribute__((retain)) __attribute__((visibility("default")))

static cv::aruco::Dictionary dictionary;
static cv::aruco::ArucoDetector detector;

void linkerPleaseInclude(bool callFunctions) {
//    if (callFunctions) {
//        initializeOpenCV();
//        DecodeResult* value = decodeMarkers(NULL, 0, 0);
//        freeDecodeResult(value);
//    }
}

__attribute__((retain)) __attribute__((visibility("default")))
void initializeOpenCV() {
    cv::aruco::DetectorParameters detectorParams = cv::aruco::DetectorParameters();
    dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_6X6_250);
    detector = cv::aruco::ArucoDetector(dictionary, detectorParams);
}

EXPORT DecodeResult* decodeMarkers(const unsigned char *imageData, int width, int height) {
    cv::Mat image(height, width, CV_8UC4, (void*)imageData);

    std::vector<std::vector<cv::Point2f>> markerCorners;
    std::vector<int> ids;
    detector.detectMarkers(image, markerCorners, ids);

    DecodeResult* result = new DecodeResult();
    result->markersCount = ids.size();
    result->markers = new Marker[result->markersCount];

    for (int marker = 0; marker < result->markersCount; ++marker) {
        result->markers[marker].id = ids[marker];
        const auto& cornerList = markerCorners[marker];
        for (int corner = 0; corner < 4; ++corner) {
            result->markers[marker].corners[corner * 2] = cornerList[corner].x;
            result->markers[marker].corners[corner * 2 + 1] = cornerList[corner].y;
        }
    }

    return result;
}

EXPORT  void freeDecodeResult(DecodeResult* result) {
    if (result) {
        delete[] result->markers;
        delete result;
    }
}

#ifdef __cplusplus
}
#endif
