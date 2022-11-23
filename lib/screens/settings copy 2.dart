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
 

  void initState() {
    super.initState();
     flutterReactiveBle.scanForDevices(withServices: [_UART_UUID], scanMode: ScanMode.lowLatency).listen((device) {
      print("object");
      print(device);
      //code for handling results
    });
  }


  void scan(){
      print("object");
    flutterReactiveBle.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency).listen((device) {
      print("device");
      print("success");
      print(device);


      setState(() {
        _foundBleUARTDevices.add(device);
      });
      //code for handling results
    }, onError: (err) {
        print("err");
      print(err);
      //code for handling error
    });
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

 
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        // title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton( child: const Text('scan ') , onPressed: scan,),
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
                          trailing: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            
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
            ),],
        ),
      ),
      );
  
}
