// ignore_for_file: non_constant_identifier_names, unused_field, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:location/location.dart';
import 'dart:io' show Platform;

import 'package:stans_cars/utils/constants.dart';
import 'package:stans_cars/utils/prefs.dart';
import 'package:stans_cars/widgets/rounded_btn.dart';

class Uart {
  String result = "";
  static Uart? _instance;
  final Uuid _UART_UUID = Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
  final Uuid _UART_RX = Uuid.parse("6E400002-B5A3-F393-E0A9-E50E24DCCA9E");
  final Uuid _UART_TX = Uuid.parse("6E400003-B5A3-F393-E0A9-E50E24DCCA9E");
  final TextEditingController _deviceSerialInputController =
      TextEditingController();
  final flutterReactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> foundBleUARTDevices = [];
  DiscoveredDevice? currentDevice;
  StreamSubscription<DiscoveredDevice>? _scanStream;
  Stream<ConnectionStateUpdate>? _currentConnectionStream;
  StreamSubscription<ConnectionStateUpdate>? _connection;
  QualifiedCharacteristic? _txCharacteristic;
  QualifiedCharacteristic? _rxCharacteristic;
  Stream<List<int>>? receivedDataStream;
  bool scanning = false;
  bool connected = false;
  bool authinticated = false;
  String _logTexts = "";
  List<String> receivedData = [];
  int _numberOfMessagesReceived = 0;
  Location location =  Location();
  bool? _serviceEnabled;

  Uart._internal();

  static Uart get instance {
    _instance ??= Uart._internal();
    return _instance!;
  }

  void noDeviceFoundToast() {
    Fluttertoast.showToast(
      msg:
          "Couldn't find your manifold, please check your manifold and try again.",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 4,
      textColor: Colors.white,
      backgroundColor: AppTheme.danger,
    );
  }

  DiscoveredDevice? getDevice(BuildContext context, String deviceId) {
    DiscoveredDevice? filteredDevice;
    for(DiscoveredDevice device in foundBleUARTDevices){
      if (deviceId == device.id){
          filteredDevice = device;
          break;
      }
    }
    if (filteredDevice == null) {
      noDeviceFoundToast();
      Navigator.of(context).pushReplacementNamed("/settings");
      return null;
    }

    return filteredDevice;
  }

  Future startScan() async {
    _serviceEnabled = await location.serviceEnabled();
    bool goForIt = false;
    PermissionStatus permission;
    if (Platform.isAndroid&&!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      permission =  await location.hasPermission();
      if (permission == PermissionStatus.granted) {
        goForIt = true;
      }
    } else if (Platform.isIOS) {
      goForIt = true;
    }
    if (goForIt) {
      //TODO replace True with permission == PermissionStatus.granted is for IOS test
      foundBleUARTDevices = [];
      scanning = true;
      _scanStream = flutterReactiveBle
          .scanForDevices(withServices: [_UART_UUID]).listen((device) {
        if (foundBleUARTDevices.every((element) => element.id != device.id)) {
          foundBleUARTDevices.add(device);
        }
      }, onError: (Object error) {
        _logTexts = "${_logTexts}ERROR while scanning:$error \n";
      });
    } else {
      print("need permission");
    }
  }

  Future sendData(String data) async {
    await flutterReactiveBle.writeCharacteristicWithResponse(_rxCharacteristic!,
        value: data.codeUnits);
  }

  void _onNewReceivedData(BuildContext context, List<int> data) {
    var msg = String.fromCharCodes(data);
    if (receivedData.isEmpty) {
      receivedData.add(msg);
      showAuthDialog(context, msg);
      return;
    }
    if (receivedData.first != msg) {
      receivedData = [msg];
    }
    showAuthDialog(context, msg);
  }

  void disconnect() async {
    await _connection!.cancel();
    connected = false;
  }

  Future stopScan() async {
    await _scanStream!.cancel();
    scanning = false;
  }

  Future<void> showAuthDialog(BuildContext context, String deviceId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(31, 116, 113, 113),
          title: Text('Authentication'),
          content: TextField(
            controller: _deviceSerialInputController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                // errorText: _error,
                label: Text(
                  'device serial number.',
                  style: TextStyle(fontSize: 16),
                )),
          ),
          actions: <Widget>[
            RoundedBtn(
                text: "Connect",
                onPressed: () {
                  print(deviceId);
                  if (_deviceSerialInputController.text != deviceId) {
                    Fluttertoast.showToast(
                      msg: "invalid serial number",
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 4,
                      textColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 231, 16, 63),
                    );
                    return;
                  }
                  Prefs prefs = Prefs.instance;
                  prefs.setDevice(currentDevice!.id);
                  authinticated = true;
                  Navigator.of(context).pushReplacementNamed("/home");
                },
                width: double.infinity)
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     child: const Text('Connect'),
            //     onPressed: () async {
            //       await uart.sendData("getid");
            //       print("uart.receivedData.toString()");
            //       print(uart.receivedData.toString());
            //       print(uart.receivedData[0]);
            //       print(_dataToSendText!.text != uart.receivedData[0]);
            //       if (_dataToSendText!.text != uart.receivedData[0]) {
            //         Fluttertoast.showToast(
            //           msg: "invalid serial number",
            //           toastLength: Toast.LENGTH_SHORT,
            //           timeInSecForIosWeb: 4,
            //           textColor: Colors.white,
            //           backgroundColor: Color.fromARGB(255, 231, 16, 63),
            //         );
            //         print("invliad");

            //         return;
            //       }

            //       await prefs.setString("id", uart.receivedData[0]);
            //       await prefs.setString("mac", uart.deviceId!);
            //       await prefs.setString("name", uart.deviceName!);
            //       await Fluttertoast.showToast(
            //         msg: "connected to the device successfully",
            //         toastLength: Toast.LENGTH_SHORT,
            //         timeInSecForIosWeb: 4,
            //         textColor: Colors.white,
            //         backgroundColor: Color.fromARGB(255, 4, 228, 4),
            //       );
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => Home()),
            //       );
            //     },
            //   ),
            // ),
          ],
        );
      },
    );
  }

  void connectToast() {
    Fluttertoast.showToast(
      msg: "connected to ble device successfully",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 4,
      textColor: Colors.white,
      backgroundColor: AppTheme.success,
    );
  }

  void onConnectDevice(BuildContext context, DiscoveredDevice device , {bool initialConnection = false}) {
    Prefs prefs = Prefs.instance;
    String? savedDevice = prefs.getDevice();
    _currentConnectionStream = flutterReactiveBle.connectToAdvertisingDevice(
      id: device.id,
      prescanDuration: const Duration(seconds: 1),
      withServices: [_UART_UUID, _UART_RX, _UART_TX],
    );
    _logTexts = "";
    _connection = _currentConnectionStream!.listen((event) {
      var id = event.deviceId.toString();
      switch (event.connectionState) {
        case DeviceConnectionState.connecting:
          {
            _logTexts = "${_logTexts}Connecting to $id\n";
            break;
          }
        case DeviceConnectionState.connected:
          {
            print("connected from connected");
            connected = true;
            currentDevice = device;
            _logTexts = "${_logTexts}Connected to $id\n";
            _numberOfMessagesReceived = 0;
            receivedData = [];
            _txCharacteristic = QualifiedCharacteristic(
                serviceId: _UART_UUID,
                characteristicId: _UART_TX,
                deviceId: event.deviceId);
            receivedDataStream = flutterReactiveBle
                .subscribeToCharacteristic(_txCharacteristic!);
            _rxCharacteristic = QualifiedCharacteristic(
                serviceId: _UART_UUID,
                characteristicId: _UART_RX,
                deviceId: event.deviceId);
            receivedDataStream!.listen((data) {
              _onNewReceivedData(context, data);
            }, onError: (dynamic error) {
              _logTexts = "${_logTexts}Error:$error$id\n";
            });

            // handle logic if the user dosn't have saved devices or connecting to new device
            // sendign getid to authinticate with the device
            if (savedDevice == null || savedDevice != device.id) {
              sendData("getid");
            } else {
              authinticated = true;
              connectToast();
              Navigator.of(context).pushReplacementNamed("/home");
            }

            break;
          }
        case DeviceConnectionState.disconnecting:
          {
            Fluttertoast.showToast(
              msg: "disconnecting ....",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 4,
              textColor: Colors.white,
              backgroundColor: AppTheme.danger,
            );
            connected = false;
            _logTexts = "${_logTexts}Disconnecting from $id\n";
            break;
          }
        case DeviceConnectionState.disconnected:
          {
            if(initialConnection){
              onConnectDevice(context, device);
            } else {
              Fluttertoast.showToast(
                msg: "disconnected ....",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 4,
                textColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 231, 16, 63),
              );
              _logTexts = "${_logTexts}Disconnected from $id\n";
            }
            break;
          }
      }
    });
  }
}
