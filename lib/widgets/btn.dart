import 'package:flutter/material.dart';

class AppBtn extends StatelessWidget {
  const AppBtn({
    Key? key,
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.width,
    this.height,
  }) : super(key: key);

  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
        width: width,
        height: height,
        child: ElevatedButton(onPressed: () {}, child: Text("asd")));
  }
}
