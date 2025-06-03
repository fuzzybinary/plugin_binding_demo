#ifndef ANDROID_OPENCV_WRAPPER_H
#define ANDROID_OPENCV_WRAPPER_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
  int id;
  // x1, y1, x2, y2, x3, y3, x4, y4
  float corners[8];
} Marker;

typedef struct {
  int markersCount;
  Marker* markers;
} DecodeResult;

void initializeOpenCV();

void freeDecodeResult(DecodeResult* result);

DecodeResult* decodeMarkers(const uint8_t* imageData, int width, int height);

#ifdef __cplusplus
};
#endif

#endif  // ANDROID_OPENCV_WRAPPER_H
