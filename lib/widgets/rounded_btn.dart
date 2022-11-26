// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:stans_cars/utils/constants.dart';

class RoundedBtn extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final double? width;

  const RoundedBtn({
    super.key,
    required this.text,
    required this.onPressed,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          boxShadow: [AppTheme.mainShadow],
          gradient: AppTheme.mainGredient,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(child: Text(text, style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 18))),
      ),
    );
  }
}
