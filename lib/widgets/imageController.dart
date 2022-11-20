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
  String baseImg = 'assets/home.png';
  String imgUrl = 'assets/home.png';
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (builderContext, constraints) {
      return SizedBox(
          width: 400,
          child: Stack(children: [
            // SizedBox(
            //   width: 350,
            //   // height: 400,
            //   // padding: const EdgeInsets.all(1),
            //   child: Image.asset(imgUrl),
            // ),

            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(imgUrl),
            ),
            //all up
            Expanded(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    // widthFactor: 1.1,
                    child: Column(
                      children: [
                        sideBtn('assets/RearUp.png'),
                        largeSpacer(),
                        sideBtn('assets/RearDown.png'),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    // widthFactor: 1.1,
                    child: Column(
                      children: [
                        alllBtn('assets/AllUp.png'),
                        tinySpacer(),
                        presettBtn('assets/pr1.png'),
                        presettBtn('assets/pr2.png'),
                        largeSpacer(),
                        presettBtn('assets/pr4.png'),
                        presettBtn('assets/pr5.png'),
                        tinySpacer(),
                        alllBtn('assets/AllDown.png'),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    // widthFactor: 1.1,
                    child: Column(
                      children: [
                        sideBtn('assets/FrontUp.png'),
                        largeSpacer(),
                        sideBtn('assets/FrontDown.png'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]));
    });
  }

  Widget presettBtn(String img) {
    double sideWidth = 200;
    double sideHeihgt = 80;
    return SizedBox(
        width: sideWidth,
        height: sideHeihgt,
        child: GestureDetector(
          onDoubleTap: () async {
            isDisabled = true;
            setState(() {
              imgUrl = baseImg;
            });
            for (var i = 0; i < 10; i++) {
              print(i);
              print('i');
              await Future.delayed(const Duration(milliseconds: 500), () {
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
        ));
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

  Widget sideBtn(String img) {
    double sideWidth = 90;
    double sideHeihgt = 120;
    return SizedBox(
        width: sideWidth,
        height: sideHeihgt,
        child: GestureDetector(
          onPanDown: (onPan) async {
            if (isDisabled) return;
            print('OnPan');

            setState(() {
              imgUrl = img;
            });
            // }
            // _changeButtonColor();
          },
          onPanEnd: (end) async {
            if (isDisabled) return;
            print('OnPan end');

            setState(() {
              imgUrl = baseImg;
            });
            // print('canceled');
          },
        ));
  }

  Widget alllBtn(String img) {
    double allWidth = 120;
    double allHeihgt = 60;
    return SizedBox(
        width: allWidth,
        height: allHeihgt,
        child: GestureDetector(
          onPanDown: (onPan) async {
            if (isDisabled) return;
            print('OnPan');

            setState(() {
              imgUrl = img;
            });
            // }
            // _changeButtonColor();
          },
          onPanEnd: (end) async {
            if (isDisabled) return;
            print('OnPan end');

            setState(() {
              imgUrl = baseImg;
            });
            // print('canceled');
          },
        ));
  }

}
