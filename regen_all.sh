#!/usr/bin/env bash

# Build the apk first to make sure the cache is up to date
flutter build apk

dart run ffigen opencv_ffigen.yaml
dart run jnigen opencv_jnigen.yaml
dart run ffigen audio_ffigen.yaml