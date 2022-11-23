import 'package:flutter/material.dart';
import 'package:stans_cars/screens/settings.dart';
import 'package:stans_cars/widgets/imageController.dart';

class Home extends StatelessWidget {
  Home({super.key});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xff000000),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // SizedBox(
              //   height: (screenSize.height * 0.4) - 15,
              //   child: Padding(
              //     padding: const EdgeInsets.all(1),
              //     child: Image.asset("assets/logo.png"),
              //   ),
              // ),
              Image.asset(
                "assets/logo.png",
                height: 100,
              ),
              SizedBox(
                height: 30,
              ),
              // Text(
              //   "${MediaQuery.of(context).size.height}",
              //   style: TextStyle(color: Colors.red),
              // ),
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
              Text(
                "connected",
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                // onPressed: () {},
                icon: Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
