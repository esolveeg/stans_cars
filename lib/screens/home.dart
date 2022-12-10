// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:stans_cars/screens/settings.dart';
import 'package:stans_cars/widgets/imageController.dart';

class Home extends StatelessWidget {


  Home({super.key});
  @override
  Widget build(BuildContext context) {
  double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 35,
        backgroundColor: Colors.black,
        title:Container(
          height: 35,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(height.toString()),
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
        )),
        body: Center(
          child: Column(children: [
            Padding(
                  padding:  EdgeInsets.only(top:height < 200 ? 30 : 1),
                  child: Image.asset(
                    "assets/logo.png",
                    height: 100,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
          ],),
        ),
       bottomNavigationBar:   ImageController(),

        );
  }
}
