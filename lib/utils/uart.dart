// ignore_for_file: non_constant_identifier_names, unused_field

import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:location_permissions/location_permissions.dart';
import 'dart:io' show Platform;
class Uart {
  String result = "";
  static Uart? _instance;
  final Uuid _UART_UUID = Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
  final Uuid _UART_RX   = Uuid.parse("6E400002-B5A3-F393-E0A9-E50E24DCCA9E");
  final Uuid _UART_TX   = Uuid.parse("6E400003-B5A3-F393-E0A9-E50E24DCCA9E");
  final flutterReactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> foundBleUARTDevices = [];
  StreamSubscription<DiscoveredDevice>? _scanStream;
  Stream<ConnectionStateUpdate>? _currentConnectionStream;
  StreamSubscription<ConnectionStateUpdate>? _connection;
  QualifiedCharacteristic? _txCharacteristic;
  QualifiedCharacteristic? _rxCharacteristic;
  Stream<List<int>>? _receivedDataStream;
  bool scanning = false;
  bool connected = false;
  String _logTexts = "";
  List<String> _receivedData = [];
  int _numberOfMessagesReceived = 0;
  Uart._internal();
  
  static Uart get instance {
    _instance ??= Uart._internal();
    return _instance!;
  }

Future startScan() async {
    bool goForIt=false;
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted) {
        goForIt=true;
      }
    } else if (Platform.isIOS) {
      goForIt=true;
    }
    if (goForIt) { //TODO replace True with permission == PermissionStatus.granted is for IOS test
      foundBleUARTDevices = [];
      scanning = true;
      _scanStream =
          flutterReactiveBle.scanForDevices(withServices: [_UART_UUID]).listen((
              device) {
            if (foundBleUARTDevices.every((element) =>
            element.id != device.id)) {
              foundBleUARTDevices.add(device);
            }
          }, onError: (Object error) {
            _logTexts =
                "${_logTexts}ERROR while scanning:$error \n";
          }
          );
    }
    else {
     print("need permission");
    }
  }


  Future sendData(String data ) async {
      await flutterReactiveBle.writeCharacteristicWithoutResponse(_rxCharacteristic!, value: data.codeUnits);
  }

  void _onNewReceivedData(List<int> data) {
    print(String.fromCharCodes(data));
  }
  void disconnect() async {
    await _connection!.cancel();
    connected = false;
  }
  Future stopScan() async {
    await _scanStream!.cancel();
    scanning = false;
  }

  void onConnectDevice(index) {
    _currentConnectionStream = flutterReactiveBle.connectToAdvertisingDevice(
      id:foundBleUARTDevices[index].id,
      prescanDuration: const Duration(seconds: 1),
      withServices: [_UART_UUID ,  _UART_RX, _UART_TX ],
    );
    _logTexts = "";
    _connection = _currentConnectionStream!.listen((event) {
      var id = event.deviceId.toString();
      switch(event.connectionState) {
        case DeviceConnectionState.connecting:
          {
            _logTexts = "${_logTexts}Connecting to $id\n";
            break;
          }
        case DeviceConnectionState.connected:
          {
            connected = true;
            _logTexts = "${_logTexts}Connected to $id\n";
            _numberOfMessagesReceived = 0;
            _receivedData = [];
            _txCharacteristic = QualifiedCharacteristic(serviceId: _UART_UUID, characteristicId: _UART_TX, deviceId: event.deviceId);
            _receivedDataStream = flutterReactiveBle.subscribeToCharacteristic(_txCharacteristic!);
            _receivedDataStream!.listen((data) {
               _onNewReceivedData(data);
            }, onError: (dynamic error) {
              _logTexts = "${_logTexts}Error:$error$id\n";
            });
            _rxCharacteristic = QualifiedCharacteristic(serviceId: _UART_UUID, characteristicId: _UART_RX, deviceId: event.deviceId);
            break;
          }
        case DeviceConnectionState.disconnecting:
          {
            connected = false;
            _logTexts = "${_logTexts}Disconnecting from $id\n";
            break;
          }
        case DeviceConnectionState.disconnected:
          {
            _logTexts = "${_logTexts}Disconnected from $id\n";
            break;
          }
      }
    });
  }

  
}