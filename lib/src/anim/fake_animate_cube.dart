import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FakeAnimateCube extends StatefulWidget {
  static Map<String, WidgetBuilder> routeNameMap = {
    "/FakeAnimateCube": (context) => FakeAnimateCube()
  };

  @override
  _FakeAnimateCubeState createState() => _FakeAnimateCubeState();
}

class _FakeAnimateCubeState extends State<FakeAnimateCube>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _color;
  Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animationController.addListener(() {
      setState(() {});
    });
    _color = ColorTween(begin: Colors.black, end: Colors.white)
        .animate(_animationController);
    _progress = Tween(begin: -1.0, end: 1.0).animate(_animationController);
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color.value,
      child: buildPerspectiveCubes(),
    );
  }

  buildPerspectiveCubes() {
    var size = MediaQuery.of(context).size;
    var landscape = size.width / size.height > 1;
    return landscape
        ? Row(
            children: [
              Expanded(
                  child: _Cube(size.width / 2, size.height, _progress.value)),
              Expanded(
                  child: _Cube(size.width / 2, size.height, _progress.value))
            ],
          )
        : Column(
            children: [
              Expanded(
                  child: _Cube(size.width, size.height / 2, _progress.value)),
              Expanded(
                  child: _Cube(size.width, size.height / 2, _progress.value)),
            ],
          );
  }
}

class _Cube extends StatelessWidget {
  final double width;
  final double height;
  final double progress;

  _Cube(this.width, this.height, this.progress);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CubePainter(progress),
      willChange: true,
      size: Size(width, height),
    );
  }
}

class _CubePainter extends CustomPainter {
  static final cubePoints = [
    [0.0, 0.0],
    [1.0, 0.0],
    [1.0, -1.0],
    [0.0, -1.0],
    [0.7071067811865474, -0.7071067811865477], //cos45º, sin45º
    [0.7071067811865474, -1 - 0.7071067811865477], //cos45º, sin45º
    [1 + 0.7071067811865474, -0.7071067811865477], //cos45º, sin45º
    [1 + 0.7071067811865474, -1 - 0.7071067811865477], //cos45º, sin45º
  ];

  static final cubeFaces = [
    [cubePoints[4], cubePoints[5], cubePoints[7], cubePoints[6]], //Back
    [cubePoints[0], cubePoints[4], cubePoints[6], cubePoints[1]], //Bottom
    [cubePoints[0], cubePoints[3], cubePoints[5], cubePoints[4]], //Left
    [cubePoints[1], cubePoints[2], cubePoints[7], cubePoints[6]], //Right
    [cubePoints[2], cubePoints[3], cubePoints[5], cubePoints[7]], //UP
    [cubePoints[0], cubePoints[3], cubePoints[2], cubePoints[1]], //FRONT
  ];

  static final edgeWidth = 4.0;
  static final shadowWidth = 2.0;

  final double progress;

  _CubePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = edgeWidth
      ..style = PaintingStyle.stroke
      ..color = Colors.blue
      ..isAntiAlias = true
      ..strokeJoin = StrokeJoin.round;
    Path path = Path();

    double baseWidth = min(size.width, size.height) / 3;

    for (int i = 0; i < cubeFaces.length; i++) {
      var p = cubeFaces[i];
      path.reset();
      for (var j = 0, l = p.length; j < l; j++) {
        double x = p[j][0] * baseWidth + size.width / 4;
        double y = p[j][1] * baseWidth + size.height * 2 / 3;
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
//          appendShadowLine(
//              canvas,
//              Offset(p[j - 1][0] * baseWidth + size.width / 4,
//                  p[j - 1][1] * baseWidth + size.height / 2),
//              Offset(x, y));
        }
      }
      path.close();
      canvas.drawPath(path, paint);
      if (!kIsWeb) {
        // this would slow in web platform
        canvas.drawShadow(path, Colors.black, 1.0, true);
      }
    }
  }

//  void appendShadowLine(Canvas canvas, Offset start, Offset end) {
//    final offset = Offset(edgeWidth / 2 + shadowWidth, 0);
//
//    Paint paint = Paint()
//      ..strokeWidth = shadowWidth
//      ..strokeJoin = StrokeJoin.round
//      ..style = PaintingStyle.stroke
//      ..shader = ui.Gradient.linear(
//          start,
//          end,
//          [Colors.white, Colors.white, Colors.black, Colors.black],
//          [0, 0.1 + 0.9 * progress, 0.9 + 0.1 * progress, 1.0]);
//
//    Paint reversePaint = Paint()
//      ..strokeWidth = shadowWidth
//      ..strokeJoin = StrokeJoin.round
//      ..style = PaintingStyle.stroke
//      ..shader = ui.Gradient.linear(
//          start,
//          end,
//          [Colors.black, Colors.black, Colors.white, Colors.white],
//          [0, 0.1 + 0.9 * progress, 0.9 + 0.1 * progress, 1.0]);
//
//    canvas.drawLine(start - offset, end - offset, paint);
//    canvas.drawLine(start + offset, end + offset, reversePaint);
//  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
