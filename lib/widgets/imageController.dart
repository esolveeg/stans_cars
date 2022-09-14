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

      return SizedBox(
        width: screenSize.height > 800
            ? (screenSize.width * .88)
            : (screenSize.width * .69),
        child: imageWidget(imageSize),
      );
    });
  }

  Stack imageWidget(Size imageSize) {
    double allBtnHeight = imageSize.height * 0.080;
    double allBtnWidth = imageSize.width * 0.25;
    double doubleTabBtnHeight = imageSize.height * 0.078;

    double doubleTabLargeBtnHeight = imageSize.height * 0.1;
    double doubleTabLargeBtnWidth = imageSize.width * 0.5;
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(1),
        child: Image.asset("assets/home.png"),
      ),
      //all up
      AppBtn(
          right: imageSize.width - (imageSize.width * 0.68),
          width: allBtnWidth,
          height: allBtnHeight),
      // all down
      AppBtn(
          bottom: 0,
          right: imageSize.width - (imageSize.width * 0.68),
          width: allBtnWidth,
          height: allBtnHeight),
      // double tab preset 1
      AppBtn(
          top: allBtnHeight,
          right: imageSize.width - (imageSize.width * 0.68),
          width: allBtnWidth,
          height: doubleTabBtnHeight),
      // double tab preset 2
      AppBtn(
          top: allBtnHeight + doubleTabBtnHeight,
          right: imageSize.width - (imageSize.width * 0.68),
          width: allBtnWidth,
          height: doubleTabBtnHeight),
      // double tab preset 3
      AppBtn(
          top: allBtnHeight + (doubleTabBtnHeight * 2),
          right: imageSize.width - (imageSize.width * 0.68),
          width: doubleTabLargeBtnWidth,
          height: doubleTabLargeBtnHeight),
    ]);
  }
}
