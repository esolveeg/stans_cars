import 'package:flutter/material.dart';
import 'package:stans_cars/screens/home.dart';
import 'package:stans_cars/widgets/imageController.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stans Lap',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            headline1: TextStyle(color: Colors.white),
          )),
      home:  Home(),
    );
  }
}
