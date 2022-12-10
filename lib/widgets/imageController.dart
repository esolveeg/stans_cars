// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stans_cars/data/models/presetModel.dart';
import 'package:stans_cars/utils/prefs.dart';
import 'package:stans_cars/utils/uart.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImageController extends StatefulWidget {
  const ImageController({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageController> createState() => _ImageControllerState();
}

class _ImageControllerState extends State<ImageController> {
  final Uart uart = Uart.instance;
  bool active = false;
  Map<String, double> metrics = {
    'screenSize': 300,
    'sideW': 300,
  };
  Map<String, List<String>> keys = {
    'FrontUp': ['a', 'A'],
    'FrontDown': ['b', 'A'],
    'RearUp': ['c', 'A'],
    'RearDown': ['d', 'A'],
    'AllUp': ['e', 'A'],
    'AllDown': ['f', 'A']
  };
  String baseImg = 'assets/home.png';
  String imgUrl = 'assets/home.png';
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 450,
        width: 350,
        child: Stack(
            alignment: Alignment.bottomCenter,
            fit: StackFit.passthrough,
            children: [
              for (var i in keys.keys)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/$i.png',
                  ),
                ),
              for (var i = 1; i <= 4 ; i++) 
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/pr$i.png',
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  imgUrl,
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(width: 105, height: 100),
                        SizedBox(
                            width: 105, height: 95, child: sideBtn('RearUp')),
                        SizedBox(width: 105, height: 70),
                        SizedBox(
                            width: 105, height: 95, child: sideBtn('RearDown')),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                            width: 145, height: 60, child: alllBtn('AllUp')),
                        SizedBox(
                            width: 145,
                            height: 70,
                            child: presettBtn(0, 'assets/pr1.png')),
                        SizedBox(
                            width: 145,
                            height: 68,
                            child: presettBtn(1, 'assets/pr2.png')),
                        SizedBox(
                          width: 145,
                          height: 70,
                        ),
                        SizedBox(
                            width: 145,
                            height: 60,
                            child: presettBtn(2, 'assets/pr4.png')),
                        SizedBox(
                            width: 145,
                            height: 60,
                            child: presettBtn(3, 'assets/pr5.png')),
                        SizedBox(
                            width: 145, height: 55, child: alllBtn('AllDown')),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(width: 105, height: 100),
                        SizedBox(
                            width: 105, height: 95, child: sideBtn('FrontUp')),
                        SizedBox(width: 105, height: 70),
                        SizedBox(
                            width: 105,
                            height: 95,
                            child: sideBtn('FrontDown')),
                      ],
                    ),
                  ],
                ),
              
            ]));
  }

  Widget presettBtn(int index, String img) {
    return Container(
      decoration: BoxDecoration(
          color: active ? Color.fromARGB(48, 255, 0, 0) : Colors.transparent,
          border: Border.all(color: Colors.blueAccent)),
      child: GestureDetector(
        onDoubleTap: () async {
          if(isDisabled) return;
        isDisabled = true;
          Prefs prefs = Prefs.instance;

          PresetModel preset = prefs.getPreset(index);
        //   setState(() {
        //     imgUrl = baseImg;
        //   });
          String dataToSend = "1$index";

          print("dataToSend");
          print(dataToSend);
          
          await uart.sendData(dataToSend);
          for (var i = 0; i < 4 * (preset.frontSeconds  + preset.rearSeconds); i++) {
              await Future.delayed(const Duration(milliseconds: 250), () {
                setState(() {
                  imgUrl = i % 2 == 0 ? baseImg : img;
                });
              });
            }
          isDisabled = false;
          // while (!controller.flashing) {
          //   print("loop");
          //     setState(() {
          //       imgUrl = img;
          //     });
          //   await Future.delayed(const Duration(milliseconds: 250), () {
          //     setState(() {
          //       imgUrl = baseImg;
          //     });
          //   });
          // }
          setState(() {
            imgUrl = baseImg;
          });
          isDisabled = false;
        },
      ),
    );
  }

  Widget sideBtn(String keyName) {
    return Container(
          decoration: BoxDecoration(
              color:
                  active ? Color.fromARGB(48, 255, 0, 0) : Colors.transparent,
              border: Border.all(color: Colors.blueAccent)),
          child: GestureDetector(
            onPanDown: (onPan) async {
              if (isDisabled) return;
              isDisabled = true;
              setState(() {
                imgUrl = "assets/${keyName}.png";
              });
              await uart.sendData(keys[keyName]![0]);
            },
            onPanEnd: (end) async {
              // if (isDisabled) return;
              setState(() {
                imgUrl = imgUrl = baseImg;
              });
              await uart.sendData(keys[keyName]![1]);
              isDisabled = false;
              // print('canceled');
            },

            child: Text(""),
          )
    );
  }




  Widget alllBtn(String keyName) {
    return Container(
        decoration: BoxDecoration(
            color: active ? Color.fromARGB(48, 255, 0, 0) : Colors.transparent,
            border: Border.all(color: Colors.blueAccent)),
        child: GestureDetector(
          onPanDown: (onPan) async {
            if (isDisabled) return;
            isDisabled = true;
            setState(() {
              imgUrl = "assets/${keyName}.png";
            });
            await uart.sendData(keys[keyName]![0]);
          },
          onPanEnd: (end) async {
            setState(() {
              imgUrl = baseImg;
            });
            await uart.sendData(keys[keyName]![1]);
            isDisabled = false;
            
          },
        ));
  }
}

Widget largeSpacer() {
  return const SizedBox(
    height: 80,
  );
}

Widget tinySpacer() {
  return const SizedBox(
    height: 20,
  );
}


