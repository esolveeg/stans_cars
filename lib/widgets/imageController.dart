import 'package:flutter/material.dart';
import 'package:stans_cars/widgets/btn.dart';

class ImageController extends StatelessWidget {
  const ImageController({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (builderContext, constraints) {
      Size imageSize = MediaQuery.of(builderContext).size;
      Size screenSize = MediaQuery.of(context).size;

      return SizedBox(width: 400, child: imageWidget(imageSize, screenSize));
    });
  }

  Stack imageWidget(Size imageSize, Size screenSize) {
    double allBtnWidth = 120;
    double allBtnHeihgt = 55;
    double presetWidth = 180;
    double presetHeihgt = 75;
    double sideWidth = 100;
    double sideHeihgt = 90;
    double doubleTabBtnHeight = imageSize.height * 0.078;

    double doubleTabLargeBtnHeight = imageSize.height * 0.1;
    double doubleTabLargeBtnWidth = imageSize.width * 0.5;
    var allBtn = SizedBox(width: allBtnWidth, height: allBtnHeihgt, child: AppBtn());
    var presetBtn = SizedBox(width: presetWidth, height: presetHeihgt, child: AppBtn());
    var sideBtn = SizedBox(width: sideWidth, height: sideHeihgt, child: AppBtn());
    return Stack(children: [
      // SizedBox(
      //   width: 350,
      //   // height: 400,
      //   // padding: const EdgeInsets.all(1),
      //   child: Image.asset("assets/home.png"),
      // ),
      Align(
        alignment: Alignment.topCenter,
        child: Image.asset("assets/home.png"),
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
                  sideBtn,
                  SizedBox(
                    height: 130,
                  ),
                  sideBtn,
      
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              // widthFactor: 1.1,
              child: Column(
                children: [
                  allBtn,
                  SizedBox(
                    height: 20,
                  ),
                  presetBtn,
                  presetBtn,
                  SizedBox(
                    height: 110,
                  ),
                  presetBtn,
                  presetBtn,
                  allBtn,
      
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              // widthFactor: 1.1,
              child: Column(
                children: [
                  sideBtn,
                  SizedBox(
                    height: 130,
                  ),
                  sideBtn,
      
                ],
              ),
            ),
          ],
        ),
      ),
      //  Align(
      //   alignment: Alignment.topCenter,
      //   // widthFactor: 1.1,
      //   child: SizedBox(
      //         width: allBtnWidth,
      //         height: allBtnHeihgt,
      //     child: AppBtn(
      //       top: allBtnHeihgt ,
      //       )
      //   ),
      // ),
      // // all down
      // AppBtn(
      //     bottom: 0,
      //     right: imageSize.width - (imageSize.width * 0.68),
      //     width: allBtnWidth,
      //     height: allBtnWidth),
      // // double tab preset 1
      // AppBtn(
      //     top: allBtnWidth,
      //     right: imageSize.width - (imageSize.width * 0.68),
      //     width: allBtnWidth,
      //     height: doubleTabBtnHeight),
      // // double tab preset 2
      // AppBtn(
      //     top: allBtnWidth + doubleTabBtnHeight,
      //     right: imageSize.width - (imageSize.width * 0.68),
      //     width: allBtnWidth,
      //     height: doubleTabBtnHeight),
      // // double tab preset 3
      // AppBtn(
      //     top: allBtnWidth + (doubleTabBtnHeight * 2),
      //     right: imageSize.width - (imageSize.width * 0.68),
      //     width: doubleTabLargeBtnWidth,
      //     height: doubleTabLargeBtnHeight),
    ]);
  }
}
