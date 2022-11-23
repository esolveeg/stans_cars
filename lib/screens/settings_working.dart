import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:stans_cars/widgets/imageController.dart';
import 'package:location_permissions/location_permissions.dart';
import 'dart:io' show Platform;
Uuid _UART_UUID = Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
Uuid _UART_RX   = Uuid.parse("6E400002-B5A3-F393-E0A9-E50E24DCCA9E");
Uuid _UART_TX   = Uuid.parse("6E400003-B5A3-F393-E0A9-E50E24DCCA9E");
class Settings extends StatefulWidget {
   Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
 final flutterReactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> _foundBleUARTDevices = [];
  StreamSubscription<DiscoveredDevice>? _scanStream;
  Stream<ConnectionStateUpdate>? _currentConnectionStream;
  StreamSubscription<ConnectionStateUpdate>? _connection;
  QualifiedCharacteristic? _txCharacteristic;
  QualifiedCharacteristic? _rxCharacteristic;
  Stream<List<int>>? _receivedDataStream;
  TextEditingController? _dataToSendText;
  bool _scanning = false;
  bool _connected = false;
  String _logTexts = "";
  List<String> _receivedData = [];
  int _numberOfMessagesReceived = 0;

  void initState() {
    super.initState();
    _dataToSendText = TextEditingController();
  }

  void refreshScreen() {
    setState(() {});
  }

  Future _sendData() async {
                            print("sending from sed");
                            print( _dataToSendText!.text);

      await flutterReactiveBle.writeCharacteristicWithoutResponse(_rxCharacteristic!, value: _dataToSendText!.text.codeUnits);
  }

  void onNewReceivedData(List<int> data) {
    _numberOfMessagesReceived += 1;
    _receivedData.add( "$_numberOfMessagesReceived: ${String.fromCharCodes(data)}");
    if (_receivedData.length > 5) {
      _receivedData.removeAt(0);
    }
    refreshScreen();
  }

  void _disconnect() async {
    await _connection!.cancel();
    _connected = false;
    refreshScreen();
  }

  void _stopScan() async {
    await _scanStream!.cancel();
    _scanning = false;
    refreshScreen();
  }

  Future<void> showNoPermissionDialog() async => showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => AlertDialog(
          title: const Text('No location permission '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('No location permission granted.'),
                const Text('Location permission is required for BLE to function.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Acknowledge'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
    );

  void _startScan() async {
    bool goForIt=false;
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted)
        goForIt=true;
    } else if (Platform.isIOS) {
      goForIt=true;
    }
    if (goForIt) { //TODO replace True with permission == PermissionStatus.granted is for IOS test
      _foundBleUARTDevices = [];
      _scanning = true;
      refreshScreen();
      _scanStream =
          flutterReactiveBle.scanForDevices(withServices: [_UART_UUID]).listen((
              device) {
            if (_foundBleUARTDevices.every((element) =>
            element.id != device.id)) {
              _foundBleUARTDevices.add(device);
              refreshScreen();
            }
          }, onError: (Object error) {
            _logTexts =
                "${_logTexts}ERROR while scanning:$error \n";
            refreshScreen();
          }
          );
    }
    else {
      await showNoPermissionDialog();
    }
  }

  void onConnectDevice(index) {
    print("onConnectDevice(index);");
    print(_foundBleUARTDevices[index].id);
    _currentConnectionStream = flutterReactiveBle.connectToAdvertisingDevice(
      id:_foundBleUARTDevices[index].id,
      prescanDuration: Duration(seconds: 1),
      withServices: [_UART_UUID ,  _UART_RX, _UART_TX ],
    );
    _logTexts = "";
    refreshScreen();
    _connection = _currentConnectionStream!.listen((event) {
    print("object");
    print(event.connectionState);
      var id = event.deviceId.toString();
      switch(event.connectionState) {
        case DeviceConnectionState.connecting:
          {
            _logTexts = "${_logTexts}Connecting to $id\n";
            break;
          }
        case DeviceConnectionState.connected:
          {
            _connected = true;
            _logTexts = "${_logTexts}Connected to $id\n";
            _numberOfMessagesReceived = 0;
            _receivedData = [];
            _txCharacteristic = QualifiedCharacteristic(serviceId: _UART_UUID, characteristicId: _UART_TX, deviceId: event.deviceId);
            _receivedDataStream = flutterReactiveBle.subscribeToCharacteristic(_txCharacteristic!);
            _receivedDataStream!.listen((data) {
               onNewReceivedData(data);
            }, onError: (dynamic error) {
              _logTexts = "${_logTexts}Error:$error$id\n";
            });
            _rxCharacteristic = QualifiedCharacteristic(serviceId: _UART_UUID, characteristicId: _UART_RX, deviceId: event.deviceId);
            break;
          }
        case DeviceConnectionState.disconnecting:
          {
            // _connected = true;

            _connected = false;
            _logTexts = "${_logTexts}Disconnecting from $id\n";
            break;
          }
        case DeviceConnectionState.disconnected:
          {
            // _connected = true;

            _logTexts = "${_logTexts}Disconnected from $id\n";
            break;
          }
      }
      refreshScreen();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        // title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text("BLE UART Devices found:"),
            Container(
                margin: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.blue,
                  width:2
                )
              ),
              height: 100,
              child: ListView.builder(
                  itemCount: _foundBleUARTDevices.length,
                  itemBuilder: (context, index) => Card(
                        child: ListTile(
                          dense: true,
                          enabled: !((!_connected && _scanning) || (!_scanning && _connected)),
                          trailing: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              print("connect");
                              print(_scanning);
                              print((!_connected && _scanning) || (!_scanning && _connected));
                              // onConnectDevice(index);
                              (!_connected && _scanning) || (!_scanning && _connected)? (){}: onConnectDevice(index);
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              alignment: Alignment.center,
                              child: const Icon(Icons.add_link),
                            ),
                          ),
                          subtitle: Text(_foundBleUARTDevices[index].id),
                          title: Text("$index: ${_foundBleUARTDevices[index].name}"),
                    ))
              )
            ),
            const Text("Status messages:"),
            Container(
                margin: const EdgeInsets.all(3.0),
               width:1400,
               decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10),
               border: Border.all(
                  color: Colors.blue,
                  width:2
                  )
               ),
               height: 90,
               child: Scrollbar(

                   child: SingleChildScrollView(
                      child: Text(_logTexts)
               )
               )
            ),
            const Text("Received data:"),
            Container(
                margin: const EdgeInsets.all(3.0),
                width:1400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.blue,
                        width:2
                    )
                ),
                height: 90,
                child: Text(_receivedData.join("\n"))
            ),
            const Text("Send message:"),
            Container(
                margin: const EdgeInsets.all(3.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.blue,
                        width:2
                    )
                ),
                child: Row(
                    children: <Widget> [
                      Expanded(
                          child: TextField(
                            enabled: _connected,
                            controller: _dataToSendText,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter a string'
                          ),
                        )
                      ),
                      ElevatedButton(
                          child: Icon(
                            Icons.send,
                            color:_connected ? Colors.blue : Colors.grey,
                          ),
                          onPressed: _connected ?   ()async {
                           await  _sendData();
                            print("sending");
                          }: (){
                              print("not connected");
                          }
                      ),
                    ]
            ))
           ],
        ),
      ),
      persistentFooterButtons: [
        Container(
          height: 35,
          child: Column(
            children: [
              if (_scanning) const Text("Scanning: Scanning") else const Text("Scanning: Idle"),
              if (_connected) const Text("Connected") else const Text("disconnected."),
            ],
          ) ,
        ),
        ElevatedButton(
          onPressed: !_scanning && !_connected ? _startScan : (){},
          child: Icon(
            Icons.play_arrow,
            color: !_scanning && !_connected ? Colors.blue: Colors.grey,
          ),
        ),
        ElevatedButton(
          onPressed: _scanning ? _stopScan: (){},
          child: Icon(
            Icons.stop,
            color:_scanning ? Colors.blue: Colors.grey,
          )
        ),
        ElevatedButton(
            onPressed: _connected ? _disconnect: (){},
            child: Icon(
              Icons.cancel,
              color:_connected ? Colors.blue:Colors.grey,
        )
        )
      ],
    );
  
}
