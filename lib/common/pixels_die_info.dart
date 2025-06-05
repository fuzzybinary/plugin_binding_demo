import 'package:flutter/material.dart';
import 'package:jni/jni.dart';

const pixelsServiceUuid = '6e400001-b5a3-f393-e0a9-e50e24dcca9e';
const pixelsNotifyCharacteristic = '6e400001-b5a3-f393-e0a9-e50e24dcca9e';
const pixelWriteCharacteristic = '6e400002-b5a3-f393-e0a9-e50e24dcca9e';

enum PixelMessages { none, whoAreYou, iAmADie, rollState }

enum PixelRollState { unknown, rolled, handling, rolling, crooked, onFace }

@immutable
class IAmADieMessage {
  final int id;
  final int ledCount;
  final int designAndColor;
  final int pixelId;
  final int availableFlash;
  final int buildTimestamp;
  final int rollState;
  final int currentFace;
  final int batteryLevelPercent;
  final bool isCharging;

  const IAmADieMessage._({
    required this.id,
    required this.ledCount,
    required this.designAndColor,
    required this.pixelId,
    required this.availableFlash,
    required this.buildTimestamp,
    required this.rollState,
    required this.currentFace,
    required this.batteryLevelPercent,
    required this.isCharging,
  });
}

class RollStateMessage {
  final int id = PixelMessages.rollState.index;
  final PixelRollState rollState;
  final int faceIndex;

  RollStateMessage._({required this.rollState, required this.faceIndex});

  factory RollStateMessage.fromJByteArray(JByteArray bytes) {
    int id = bytes.elementAt(0);
    assert(id == PixelMessages.rollState.index);
    int rollState = bytes.elementAt(1);
    int faceIndex = bytes.elementAt(2);

    return RollStateMessage._(
      rollState: PixelRollState.values[rollState],
      faceIndex: faceIndex,
    );
  }
}
