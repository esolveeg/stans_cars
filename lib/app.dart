import 'package:flutter/material.dart';
import 'package:stans_cars/screens/home.dart';
import 'package:stans_cars/screens/settings.dart';
import 'package:stans_cars/screens/splash.dart';
import 'package:stans_cars/utils/prefs.dart';
import 'package:stans_cars/utils/uart.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.prefs,
    required this.uart,
  });

  final Prefs prefs;
  final Uart uart;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 18.0,
              fontFamily: 'English',
              color: Colors.white,
              fontWeight: FontWeight.bold),
          headline2: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'English'),
          bodyText1: TextStyle(
              fontSize: 16.0, color: Colors.white, fontFamily: 'English'),
          bodyText2: TextStyle(
              fontSize: 14.0,
              color: Color.fromARGB(255, 161, 161, 161),
              fontFamily: 'English'),
        ),
        scaffoldBackgroundColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.transparent))),
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  // If the button is pressed, return green, otherwise blue
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.green;
                  }
                  return Colors.transparent;
                }),
                textStyle: MaterialStateProperty.resolveWith((states) {
                  // If the button is pressed, return size 40, otherwise 20
                  if (states.contains(MaterialState.pressed)) {
                    return TextStyle(fontSize: 40, color: Colors.white);
                  }
                  return TextStyle(fontSize: 20, color: Colors.white);
                }),
                minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 40)))),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0xFF2c2c2c), width: 1.0),
          ),
          labelStyle: TextStyle(fontSize: 24.0),
        ),
        primarySwatch: Colors.grey,
        primaryColor: Colors.black,
        backgroundColor: const Color(0xFF000000),
        dividerColor: Color.fromARGB(78, 255, 255, 255),
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      initialRoute: "/",
      routes: {
        '/': (context) => Splash(prefs: prefs,uart: uart,),
        '/home': (context) => Home(),
        '/settings': (context) => const Settings(),
      },
    );
  }
}
