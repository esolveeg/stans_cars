import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stans_cars/components/loading.dart';
import 'package:stans_cars/screens/settings.dart';
import 'package:stans_cars/utils/uart.dart';
import 'package:stans_cars/widgets/imageController.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Uart uart = Uart.instance;
  bool scaning = false;
  bool connected = false;
  @override
  void initState() {
    super.initState();

    scan();
  }
  
  Future scan() async {
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

  Future connect(int index) async {
     uart.onConnectDevice(index);
  }
  void _refreshScreen() {
    setState(() {});
  }

  @override
  void dispose() {
    uart.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
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
            title: const Text('Settings'),
            centerTitle: true,
            backgroundColor: Colors.black,
          ),
          body: TabBarView(
            children: [
              scaning ? const Padding(
                padding:  EdgeInsets.all(8.0),
                child: Center(child: Text("scanning" , style: TextStyle(color: Colors.white),)),
              ) : 
              RefreshIndicator(
                onRefresh: ()async {
                  print("before");
                  
                  scan();
                  print("after");
                },
                child: ListView.builder(
                    itemCount: uart.foundBleUARTDevices.length,
                    itemBuilder: (context, index) => Card(
                        color: Color.fromARGB(31, 116, 113, 113),
                        child: ListTile(
                          dense: true,
                          // enabled: !((!_connected && _scanning) || (!_scanning && _connected)),
                          trailing: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              print("connecting");
                              connect(index);
                              print("connected");
                              // (!_connected && _scanning) || (!_scanning && _connected)? (){}: onConnectDevice(index);
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              alignment: Alignment.center,
                              child: const Icon(Icons.add_link),
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
                        ))),
              ),
              Icon(Icons.directions_transit)
            ],
          ),
        ),
      ),
    );
  }
}
