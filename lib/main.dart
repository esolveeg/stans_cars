import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stans_cars/app.dart';
import 'package:stans_cars/utils/prefs.dart';
import 'package:stans_cars/utils/uart.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = Prefs.instance;
  var uart = Uart.instance;
  await prefs.init();
  uart.startScan();
  runApp(App(prefs: prefs, uart: uart));
}
