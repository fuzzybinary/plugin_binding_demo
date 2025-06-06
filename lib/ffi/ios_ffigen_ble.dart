import 'package:flutter/material.dart';
import 'package:objective_c/objective_c.dart';

import '../common/pixels_die_info.dart';
import '../core_bluetooth.dart';

class IosFfigenBle extends StatefulWidget {
  const IosFfigenBle({super.key});

  @override
  State<IosFfigenBle> createState() => _JniGenBleState();
}

class _JniGenBleState extends State<IosFfigenBle> {
  CBCentralManager? _centralManager;
  CBCentralManagerDelegate? _centralDelegate;
  CBPeripheralDelegate? _peripheralDelegate;
  CBPeripheral? _peripheral;

  String currentConnectionStatus = 'Connecting...';
  String? lastRollingStatus;

  @override
  void initState() {
    super.initState();

    _startScan();
  }

  @override
  void dispose() {
    super.dispose();
    if (_peripheral != null) {
      _centralManager?.cancelPeripheralConnection(_peripheral!);
    }
    _stopScan();
  }

  void _setConnectionStatus(String status) {
    setState(() {
      currentConnectionStatus = status;
    });
  }

  void _startScan() {
    _setConnectionStatus('Creating Central...');

    _centralDelegate = CBCentralManagerDelegate.implementAsListener(
      centralManagerDidUpdateState_: (centralManager) {
        switch (centralManager.state) {
          case CBManagerState.CBManagerStateUnknown:
            _setConnectionStatus('Manager is in unknown state');
            break;
          case CBManagerState.CBManagerStateResetting:
            _setConnectionStatus('Manager is currently resetting');
            break;
          case CBManagerState.CBManagerStateUnsupported:
            _setConnectionStatus('BLE Unsupported');
            break;
          case CBManagerState.CBManagerStateUnauthorized:
            _setConnectionStatus('Getting Authorized...');
            break;
          case CBManagerState.CBManagerStatePoweredOff:
            _setConnectionStatus('BLE is off.');
            break;
          case CBManagerState.CBManagerStatePoweredOn:
            _setConnectionStatus('Scanning...');
            centralManager.scanForPeripheralsWithServices(
              [
                CBUUID.UUIDWithString(pixelsServiceUuid.toNSString()),
              ].toNSArray(),
            );
            break;
        }
      },
      centralManager_didDiscoverPeripheral_advertisementData_RSSI_: (
        central,
        peripheral,
        advertisementData,
        rssi,
      ) {
        _setConnectionStatus('Connecting...');
        central.connectPeripheral(peripheral);
        _peripheral = peripheral;
      },
      centralManager_didConnectPeripheral_: (central, peripheral) {
        _setConnectionStatus('Discovering services...');
        peripheral.delegate = _createPeripheralDelegate();
        peripheral.discoverServices(null);
      },
    );

    _centralManager = CBCentralManager.alloc().initWithDelegate(
      _centralDelegate,
    );
  }

  CBPeripheralDelegate _createPeripheralDelegate() {
    _peripheralDelegate = CBPeripheralDelegate.implementAsListener(
      peripheral_didDiscoverServices_: (peripheral, error) {
        if (peripheral.services case final services?) {
          for (final obj in services) {
            final service = CBService.castFrom(obj);
            if (service.UUID.UUIDString.toDartString() ==
                pixelsServiceUuid.toUpperCase()) {
              _setConnectionStatus('Discovering characteristics...');
              peripheral.discoverCharacteristics(null, forService: service);
            }
          }
        } else {
          _setConnectionStatus('Found no services...');
        }
      },
      peripheral_didDiscoverCharacteristicsForService_error_: (
        peripheral,
        service,
        error,
      ) {
        if (service.characteristics case final characteristics?) {
          for (final obj in characteristics) {
            final characteristic = CBCharacteristic.castFrom(obj);
            if (characteristic.UUID.UUIDString.toDartString() ==
                pixelsNotifyCharacteristic.toUpperCase()) {
              peripheral.setNotifyValue(
                true,
                forCharacteristic: characteristic,
              );
              _setConnectionStatus('Connected!');
            }
          }
        } else {
          _setConnectionStatus('Found no characteristics...');
        }
      },
      peripheral_didUpdateValueForCharacteristic_error_: (
        peripheral,
        characteristic,
        error,
      ) {
        final data = characteristic.value;
        if (data != null) {
          _gotCharacteristicChange(data.toList());
        }
      },
    );

    return _peripheralDelegate!;
  }

  void _stopScan() {
    _centralManager?.stopScan();
    _centralManager = null;
  }

  void _gotCharacteristicChange(List<int> message) {
    int messageId = message.elementAt(0);
    if (messageId == PixelMessages.rollState.index) {
      final RollStateMessage rollState = RollStateMessage.fromByteList(message);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('CoreBluetooth')),
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
  }
}
