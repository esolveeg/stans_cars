import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stans_cars/utils/constants.dart';
import 'package:stans_cars/utils/prefs.dart';
import 'package:stans_cars/utils/uart.dart';

class Splash extends StatefulWidget {
  final Prefs prefs;
  final Uart uart;
  const Splash({super.key, required this.prefs, required this.uart});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool scanning = true;
  bool connecting = false;
  @override
  void initState() {
    var deviceInfo = widget.prefs.getDevice();
    var uart = widget.uart;
    Timer(const Duration(seconds: 5), () async {
      widget.uart.stopScan();
      setState(() {
        scanning = false;
      });
      if (deviceInfo == null) {
        Navigator.of(context).pushReplacementNamed("/settings");
      } else {
        var device = uart.getDevice(context , deviceInfo);
        if (device != null)  {
          // uart.disconnect();
          setState(() {
            connecting = true;
          });
          uart.onConnectDevice(context, device , initialConnection: true);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/splash.png",
            width: 200,
            height: 200,
          ),
          SizedBox(
            height: 10,
          ),
          CircularProgressIndicator(),

          // if (scanning) Text("scaning"),
          if (connecting) Text("connecting"),
        ],
      )),
    );
  }
}
