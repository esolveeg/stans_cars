import 'package:flutter/material.dart';
import 'package:stans_cars/widgets/btn.dart';

class ImageController extends StatefulWidget {
  const ImageController({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageController> createState() => _ImageControllerState();
}

class _ImageControllerState extends State<ImageController> {
  Map<String , double> metrics = {
    'screenSize' : 400,
    'sideW' : 400,
    'screenSize' : 400,
    'screenSize' : 400,

  };
  Map<String, List<String>> keys = {
    'FrontUp': ['!B516', '!B507'],
    'FrontDown': ['!B615', '!B606'],
    'RearUp': ['!B813', '!B804'],
    'RearDown': ['!B714', '!B705'],
    'AllUp': ['!B10;', '!B20;'],
    'AllDown': ['!B309', '!B408']
  };
  String baseImg = 'assets/home.png';
  String imgUrl = 'assets/home.png';
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (builderContext, constraints) {
      return SizedBox(
          width: metrics['screenSize'],
          child: Stack(children: [
            // SizedBox(
            //   width: 350,
            //   // height: 400,
            //   // padding: const EdgeInsets.all(1),
            //   child: Image.asset(imgUrl),
            // ),
            for ( var i in keys.keys ) Align(
              alignment: Alignment.topCenter,
              child: Image.asset('assets/$i.png'),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(imgUrl),
            ),
            //all up
           Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    // widthFactor: 1.1,
                    child: Column(
                      children: [
                        sideBtn('RearUp'),
                        largeSpacer(),
                        sideBtn('RearDown'),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    // widthFactor: 1.1,
                    child: Column(
                      children: [
                        alllBtn('AllUp'),
                        tinySpacer(),
                        presettBtn('assets/pr1.png'),
                        presettBtn('assets/pr2.png'),
                        largeSpacer(),
                        presettBtn('assets/pr4.png'),
                        presettBtn('assets/pr5.png'),
                        tinySpacer(),
                        alllBtn('AllDown'),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    // widthFactor: 1.1,
                    child: Column(
                      children: [
                        sideBtn('FrontUp'),
                        largeSpacer(),
                        sideBtn('FrontDown'),
                      ],
                    ),
                  ),
                ],
              ),
            
          ]));
    });
  }

  Widget presettBtn(
    String img,
  ) {
    double sideWidth = 200;
    double sideHeihgt = 80;
    return SizedBox(
        width: sideWidth,
        height: sideHeihgt,
        child:  GestureDetector(
            onDoubleTap: () async {
              isDisabled = true;
              // setState(() {
              //   imgUrl = baseImg;
              // });
              for (var i = 0; i < 10; i++) {
                print(i);
                print('i');
                await Future.delayed(const Duration(milliseconds: 250), () {
                  setState(() {
                    imgUrl = i % 2 == 0 ? baseImg : img;
                  });
                });
              }
              setState(() {
                imgUrl = baseImg;
              });
              isDisabled = false;
            },
          ),
        );
  }

  Widget sideBtn(String keyName) {
    double sideWidth = 90;
    double sideHeihgt = 120;
    return SizedBox(
        width: sideWidth,
        height: sideHeihgt,
        child: GestureDetector(
          onPanDown: (onPan) async {
            if (isDisabled) return;
            print('OnPan');
            print("send:${keys[keyName]![0]}");
            setState(() {
              imgUrl = "assets/${keyName}.png";
            });
            // }
            // _changeButtonColor();
          },
          onPanEnd: (end) async {
            if (isDisabled) return;
            print('OnPan end');
            print("send:${keys[keyName]![1]}");
            setState(() {
              imgUrl =               imgUrl = baseImg;
;
            });
            // print('canceled');
          },
        ));
  }

  Widget alllBtn(String keyName) {
    double allWidth = 120;
    double allHeihgt = 60;

    return SizedBox(
        width: allWidth,
        height: allHeihgt,
        child: GestureDetector(
          onPanDown: (onPan) async {
            if (isDisabled) return;
            print('OnPan');
print("send:${keys[keyName]![0]}");
            setState(() {
              imgUrl = "assets/${keyName}.png";
            });
            // }
            // _changeButtonColor();
          },
          onPanEnd: (end) async {
            if (isDisabled) return;
            print('OnPan end');
print("send:${keys[keyName]![1]}");

            setState(() {
              imgUrl = baseImg;
            });
            // print('canceled');
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
