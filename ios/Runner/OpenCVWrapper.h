//// Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
// This product includes software developed at Datadog (https://www.datadoghq.com/).
// Copyright 2025-Present Datadog, Inc.

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (void)setDebugLogging;
+ (NSDictionary*)detectMarkers:(int)width :(int)height :(FlutterStandardTypedData *)bytes;

@end

NS_ASSUME_NONNULL_END
