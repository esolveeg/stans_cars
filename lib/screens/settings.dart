// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:stans_cars/data/models/presetModel.dart';
import 'package:stans_cars/screens/home.dart';
import 'package:stans_cars/utils/prefs.dart';
import 'package:stans_cars/utils/uart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stans_cars/widgets/presets.dart';
import 'package:stans_cars/widgets/rounded_btn.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Uart uart = Uart.instance;
  Prefs prefs = Prefs.instance;
  List<PresetModel>? presets;
  bool scaning = false;
  bool connected = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    presets = prefs.getPresets();
    // scan();
  }

  Future scan() async {
    if (uart.connected) {
      return;
    }
    uart.startScan();
    setState(() {
      scaning = true;
    });

    Timer(const Duration(seconds: 10), () async {
      await uart.stopScan();
      setState(() {
        scaning = false;
      });
    });
  }

  Future connect(DiscoveredDevice device) async {
    if (uart.connected) {
      if (uart.currentDevice == device) {
        if (uart.authinticated) {
          Fluttertoast.showToast(
            msg: "you already connected to this device",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 4,
            textColor: Colors.white,
            backgroundColor: Color.fromARGB(255, 231, 16, 63),
          );
          return;
        }
        if (uart.receivedData.isEmpty) {
          uart.sendData("getid");
          return;
        } else {
          uart.showAuthDialog(context, uart.receivedData[0]);
          return;
        }
      }
      uart.disconnect();
    }
    uart.onConnectDevice(context, device);
  }

  void _refreshScreen() {
    setState(() {});
  }

  @override
  void dispose() {
    uart.stopScan();
    super.dispose();
  }

  Widget noDevicesFoundState() {
    return RefreshIndicator(
      onRefresh: () async {
        scan();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(
            "There is no nearby devices",
            style: Theme.of(context).textTheme.bodyText1,
          )),
          SizedBox(
            height: 30,
          ),
          RoundedBtn(
              onPressed: () {
                scan();
              },
              text: "reload",
              width: 200)
        ],
      ),
    );
  }

  Widget scaningState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 30),
        Center(
            child: Text(
          "Scaning",
          style: Theme.of(context).textTheme.bodyText1,
        )),
      ],
    );
  }

  Widget devicesState() {
    return RefreshIndicator(
      onRefresh: () async {
        scan();
      },
      child: ListView.builder(
          itemCount: uart.foundBleUARTDevices.length,
          itemBuilder: (context, index) => Card(
              color: Color.fromARGB(31, 116, 113, 113),
              child: GestureDetector(
                onTap: () {
                  connect(uart.foundBleUARTDevices[index]);
                },
                child: ListTile(
                  dense: true,
                  // enabled: !((!_connected && _scanning) || (!_scanning && _connected)),
                  trailing: Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.bluetooth_disabled_outlined,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    uart.foundBleUARTDevices[index].id,
                    style: TextStyle(color: Colors.white),
                  ),
                  title: Text(
                    "${uart.foundBleUARTDevices[index].name}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ))),
    );
  }

  Widget currentStateWidget() {
    if (scaning) {
      return scaningState();
    }

    return uart.foundBleUARTDevices.isEmpty
        ? noDevicesFoundState()
        : devicesState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.bluetooth_outlined),
                  text: "devices",
                ),
                Tab(
                  icon: Icon(Icons.bar_chart_outlined),
                  text: "presets",
                )
              ],
            ),
            title: Text('Settings'),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [currentStateWidget(), Presets(presets: presets!)],
          ),
        ),
      ),
    );
  }
}
