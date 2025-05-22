//// Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
// This product includes software developed at Datadog (https://www.datadoghq.com/).
// Copyright 2025-Present Datadog, Inc.

#include <opencv2/opencv.hpp>
#include <opencv2/core/utils/logger.hpp>
using namespace cv::utils;

#import <Foundation/Foundation.h>

#import "OpenCVWrapper.h"

@implementation OpenCVWrapper

+ (void)setDebugLogging {
    logging::setLogLevel(logging::LOG_LEVEL_VERBOSE);
}

+ (NSDictionary*)detectMarkers:(int)width :(int)height :(FlutterStandardTypedData* )bytes {
    NSData* data = [bytes data];
    cv::Mat mat(height, width, CV_8UC4, const_cast<void *>([data bytes]));

    cv::aruco::DetectorParameters detectorParameters{};
    cv::aruco::Dictionary dictionary = cv::aruco::getPredefinedDictionary(cv::aruco::DICT_6X6_250);
    cv::aruco::ArucoDetector detector(dictionary, detectorParameters);

    std::vector<int> markerIds;
    std::vector<std::vector<cv::Point2f>> markerCorners;

    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    detector.detectMarkers(mat, markerCorners, markerIds);
    NSTimeInterval diff = CFAbsoluteTimeGetCurrent() - start;

    NSMutableArray<NSNumber *>* nsMarkers = [NSMutableArray new];
    for (const auto& markerId : markerIds) {
        [nsMarkers addObject:@(markerId)];
    }
    NSMutableArray* nsMarkerCorners = [NSMutableArray new];
    for (const auto& marker : markerCorners) {
        NSMutableArray* nsCorners = [NSMutableArray new];
        for(const auto& corner : marker) {
            [nsCorners addObject:@[@(corner.x), @(corner.y)]];
        }
        [nsMarkerCorners addObject:nsCorners];
    }


    NSDictionary* result = @{
        @"markerIds": nsMarkers,
        @"markerCorners": nsMarkerCorners,
        @"classifyTime": @(diff * 1000.0)
    };
    return result;
}

@end
