// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:stans_cars/screens/settings.dart';
import 'package:stans_cars/widgets/imageController.dart';

class Home extends StatelessWidget {
  Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/logo.png",
                height: 100,
              ),
              SizedBox(
                height: 30,
              ),
              ImageController()
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 35,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("connected"),
              IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed("/settings");
                  
                },
              ),
            ],
          ),
        ));
  }
}
