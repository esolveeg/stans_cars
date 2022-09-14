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
            ? (screenSize.width * .9)
            : (screenSize.width * .69),
        child: imageWidget(imageSize),
      );
    });
  }

  Stack imageWidget(Size imageSize) {
    double allBtnHeight = imageSize.height * 0.080;
    double doubleTabBtnHeight = imageSize.height * 0.078;

    double doubleTabLargeBtnHeight = imageSize.height * 0.1;
    double doubleTabLargeBtnWidth = imageSize.width * 0.3;
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(1),
        child: Image.asset("assets/home.png"),
      ),
      //all up
      AppBtn(
          right: imageSize.width - (imageSize.width * 0.68),
          width: imageSize.width * 0.25,
          height: allBtnHeight),
      // all down
      AppBtn(
          bottom: 0,
          right: imageSize.width - (imageSize.width * 0.68),
          width: imageSize.width * 0.25,
          height: allBtnHeight),
      // double tab preset 1
      AppBtn(
          top: allBtnHeight,
          right: imageSize.width - (imageSize.width * 0.68),
          width: imageSize.width * 0.25,
          height: doubleTabBtnHeight),
      // double tab preset 2
      AppBtn(
          top: allBtnHeight + doubleTabBtnHeight,
          right: imageSize.width - (imageSize.width * 0.68),
          width: imageSize.width * 0.25,
          height: doubleTabBtnHeight),
      // double tab preset 3
      AppBtn(
          top: allBtnHeight + (doubleTabBtnHeight * 2),
          right: imageSize.width - (imageSize.width * 0.68),
          width: imageSize.width * 0.25,
          height: doubleTabLargeBtnHeight),
      //all down

      //alldown
      // AppBtn(
      //     bottom: 0,
      //     right: imageSize.width * .25,
      //     width: imageSize.width * .2,
      //     height: imageSize.height * .12),
      // //fornt down
      // AppBtn(
      //     bottom: imageSize.width * .20,
      //     right: 0,
      //     width: imageSize.width * .2,
      //     height: imageSize.width * .19),
      // //rear down
      // AppBtn(
      //     bottom: imageSize.width * .20,
      //     left: 0,
      //     width: imageSize.width * .2,
      //     height: imageSize.width * .19),
      // //rear up
      // AppBtn(
      //     top: imageSize.width * .20,
      //     left: 0,
      //     width: imageSize.width * .2,
      //     height: imageSize.width * .19),
      // //front up
      // AppBtn(
      //     top: imageSize.width * .20,
      //     right: 0,
      //     width: imageSize.width * .2,
      //     height: imageSize.width * .19),

      // // double tap btns
      // AppBtn(
      //     top: imageSize.width * .15,
      //     right: imageSize.width * .2,
      //     width: imageSize.width * .3,
      //     height: imageSize.width * .1),
      // AppBtn(
      //     top: imageSize.width * .28,
      //     right: imageSize.width * .2,
      //     width: imageSize.width * .3,
      //     height: imageSize.width * .11),
      // AppBtn(
      //     top: imageSize.width * .42,
      //     right: imageSize.width * .12,
      //     width: imageSize.width * .45,
      //     height: imageSize.width * .14),
      // AppBtn(
      //     top: imageSize.width * .58,
      //     right: imageSize.width * .2,
      //     width: imageSize.width * .3,
      //     height: imageSize.width * .11),
      // AppBtn(
      //     top: imageSize.width * .72,
      //     right: imageSize.width * .2,
      //     width: imageSize.width * .3,
      //     height: imageSize.width * .11),
    ]);
  }
}
