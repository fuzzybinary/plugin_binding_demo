import 'package:flutter/material.dart';
import 'package:jni/_internal.dart';
import 'package:jni/jni.dart';

import '../ble_jni.dart';
import '../common/pixels_die_info.dart';

class JniGenBle extends StatefulWidget {
  const JniGenBle({super.key});

  @override
  State<JniGenBle> createState() => _JniGenBleState();
}

class _JniGenBleState extends State<JniGenBle> {
  BluetoothManager? _bluetoothManager;
  BluetoothAdapter? _bluetoothAdapter;
  BluetoothAdapter$LeScanCallback? _scanCallback;

  BluetoothDevice? _connectedDevice;
  BluetoothGatt? _connectedGatt;
  BluetoothGattCharacteristic? _readCharacteristic;
  BluetoothGattCharacteristic? _writeCharacteristic;

  String currentConnectionStatus = 'Connecting...';
  String? lastRollingStatus;

  @override
  void initState() {
    super.initState();
    final context = Context.fromReference(Jni.getCachedApplicationContext());

    _bluetoothManager = context.getSystemService$1<BluetoothManager>(
      BluetoothManager.type.jClass,
      T: BluetoothManager.type,
    );
    // TODO: Once permission is granted, we don't get `initState` again, so we have
    // to leave and come back to this screen.
    _askForPermissions(context).then((value) {
      if (value) {
        _startScan();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stopScan();

    _readCharacteristic?.release();
    _readCharacteristic = null;

    _writeCharacteristic?.release();
    _writeCharacteristic = null;

    _connectedGatt?.disconnect();
    _connectedGatt?.release();

    _connectedDevice?.release();
    _connectedDevice = null;

    _bluetoothManager?.release();
    _bluetoothManager = null;
  }

  Future<bool> _askForPermissions(Context context) async {
    var permission =
        context.checkSelfPermission(Manifest$permission.BLUETOOTH_SCAN) == 0;
    permission &=
        context.checkSelfPermission(Manifest$permission.BLUETOOTH_CONNECT) == 0;
    if (permission) return true; // Granted

    // Ask for permission
    final activity = JObject.fromReference(Jni.getCurrentActivity());
    ActivityCompat.requestPermissions(
      activity,
      [
        Manifest$permission.BLUETOOTH_SCAN,
        Manifest$permission.BLUETOOTH_CONNECT,
      ].toJArray(JString.nullableType),
      2,
    );

    activity.release();
    return false;
  }

  void _setConnectionStatus(String status) {
    setState(() {
      currentConnectionStatus = status;
    });
  }

  void _startScan() {
    _setConnectionStatus('Scanning...');

    _bluetoothAdapter = _bluetoothManager?.getAdapter();
    _scanCallback = BluetoothAdapter$LeScanCallback.implement(
      $BluetoothAdapter$LeScanCallback(
        onLeScan: (device, rssi, scanRecord) {
          // Already connected, stop trying
          if (_connectedDevice != null) return;
          if (device != null) {
            _connectDevice(device);
            _stopScan();
          }
          if (scanRecord != null) scanRecord.release();
        },
      ),
    );

    _bluetoothAdapter?.startLeScan$1(
      [
        UUID.fromString(JString.fromString(pixelsServiceUuid)),
      ].toJArray(UUID.nullableType),
      _scanCallback,
    );
  }

  void _stopScan() {
    _bluetoothAdapter?.stopLeScan(_scanCallback);
    _bluetoothAdapter?.release();
    _bluetoothAdapter = null;
    _scanCallback = null;
  }

  void _gotCharacteristicChange(JByteArray message) {
    int messageId = message.elementAt(0);
    if (messageId == PixelMessages.rollState.index) {
      final RollStateMessage rollState = RollStateMessage.fromJByteArray(
        message,
      );
      setState(() {
        switch (rollState.rollState) {
          case PixelRollState.unknown:
            lastRollingStatus = 'Unknown Roll';
            break;
          case PixelRollState.rolled:
            lastRollingStatus = 'Rolled a ${rollState.faceIndex + 1}!';
            break;
          case PixelRollState.handling:
            lastRollingStatus = 'Handling...';
            break;
          case PixelRollState.rolling:
            lastRollingStatus = 'Rolling...';
            break;
          case PixelRollState.crooked:
            lastRollingStatus = 'Crooked die :(';
            break;
          case PixelRollState.onFace:
            lastRollingStatus = 'Just chilling on ${rollState.faceIndex + 1}.';
            break;
        }
      });
    }
  }

  void _connectDevice(BluetoothDevice device) {
    _setConnectionStatus('Connecting...');
    using((arena) {
      final context = Context.fromReference(Jni.getCachedApplicationContext())
        ..releasedBy(arena);
      final callback = BluetoothGattCallbackProxy$CallbackInterface.implement(
        $BluetoothGattCallbackProxy$CallbackInterface(
          onCharacteristicChanged: (
            bluetoothGatt,
            bluetoothGattCharacteristic,
            bs,
          ) {
            _gotCharacteristicChange(bs);
          },
          onCharacteristicRead:
              (bluetoothGatt, bluetoothGattCharacteristic, bs, i) {},
          onCharacteristicWrite:
              (bluetoothGatt, bluetoothGattCharacteristic, i) {},
          onConnectionStateChange: (bluetoothGatt, status, newState) {
            if (newState == BluetoothProfile.STATE_CONNECTED) {
              bluetoothGatt.requestMtu(517);
              _setConnectionStatus('Discovering services...');
              bluetoothGatt.discoverServices();
            }
          },
          onDescriptorRead: (bluetoothGatt, bluetoothGattDescriptor, i, bs) {},
          onDescriptorWrite: (bluetoothGatt, bluetoothGattDescriptor, i) {},
          onMtuChanged: (bluetoothGatt, i, i1) {
            print('MTU Changed $i, $i1');
          },
          onPhyRead: (bluetoothGatt, i, i1, i2) {},
          onPhyUpdate: (bluetoothGatt, i, i1, i2) {},
          onReadRemoteRssi: (bluetoothGatt, i, i1) {},
          onReliableWriteCompleted: (bluetoothGatt, i) {},
          onServiceChanged: (bluetoothGatt) {},
          onServicesDiscovered: (bluetoothGatt, i) {
            final pixelsService = bluetoothGatt.getService(
              uuidFromDartString(pixelsServiceUuid),
            );
            if (pixelsService != null) {
              _readCharacteristic = pixelsService.getCharacteristic(
                uuidFromDartString(pixelsNotifyCharacteristic),
              );
              final descriptors = _readCharacteristic?.getDescriptors();
              if (descriptors != null) {
                for (final descriptor in descriptors) {
                  descriptor!.setValue(
                    BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE,
                  );
                  bluetoothGatt.writeDescriptor(descriptor);
                }
              }
              _writeCharacteristic = pixelsService.getCharacteristic(
                uuidFromDartString(pixelWriteCharacteristic),
              );
              bluetoothGatt.setCharacteristicNotification(
                _readCharacteristic,
                true,
              );
              _setConnectionStatus('Connected');
            } else {
              _setConnectionStatus('Not a Pixel Die?');
            }
          },
        ),
      );

      _setConnectionStatus('Connecting GATT...');
      _connectedDevice = device;
      _connectedGatt = device.connectGatt(
        context,
        true,
        BluetoothGattCallbackProxy(callback),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return using((arena) {
      return Scaffold(
        appBar: AppBar(title: Text('Bluetooth JNI')),
        body: Center(
          child: Column(
            children: [
              Text(
                currentConnectionStatus,
                style: theme.textTheme.headlineMedium,
              ),
              if (lastRollingStatus != null) ...[
                Divider(),
                Text(lastRollingStatus!, style: theme.textTheme.headlineMedium),
              ],
            ],
          ),
        ),
      );
    });
  }
}

UUID? uuidFromDartString(String dartString) {
  return UUID.fromString(JString.fromString(dartString));
}

extension ToJavaArray<E extends JObject?> on Iterable<E> {
  // ignore: invalid_use_of_internal_member
  JArray<E> toJArray(JObjType<E> type) {
    final array = JArray(type, length);
    for (var e in indexed) {
      array[e.$1] = e.$2;
    }
    return array;
  }
}
