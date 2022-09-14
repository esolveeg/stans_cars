import 'package:flutter/material.dart';
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
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0x44000000),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: (screenSize.height * 0.4) - 15,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: Image.asset("assets/hights.png"),
                ),
              ),
              Text(
                "${MediaQuery.of(context).size.height}",
                style: TextStyle(color: Colors.red),
              ),
              ImageController()
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 25,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "connected",
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
            ],
          ),
        ));
  }
}
