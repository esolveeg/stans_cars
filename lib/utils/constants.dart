// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AppTheme {
  static final mainGredient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    colors: const [
      Color.fromARGB(255, 42, 101, 150),
      Color.fromARGB(255, 26, 63, 94),
    ],
  );
  static final danger = Color.fromARGB(255, 173, 1, 1);
  static final success = Color.fromARGB(255, 4, 228, 4);
  static final main = Color.fromARGB(255, 26, 63, 94);
  static final mainShadow = BoxShadow(
      color: Color.fromARGB(255, 42, 101, 150).withAlpha(150),
      offset: Offset(0, 4),
      blurRadius: 5.0);
}
