import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Galaxy extends StatefulWidget {
  static Map<String, WidgetBuilder> routeNameMap = {
    "/Galaxy": (context) => Galaxy()
  };

  @override
  _GalaxyState createState() => _GalaxyState();
}

const _kDefaultCircleSize = 20.0;
const _kDefaultCircleRadius = 100.0;
const _kAnimationDuration = 4000;
const _kBlurRadius = 24.0;
const _kSpreadRadius = 16.0;

class _GalaxyState extends State<Galaxy> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  Offset panOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: _kAnimationDuration),
      vsync: this,
    );
    animationController.addListener(() {
      setState(() {});
    });
    animation =
        Tween(begin: 0.0, end: 2 * math.pi).animate(animationController);
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateX(0.01 * panOffset.dy), // changed
      alignment: FractionalOffset.center,
      child: GestureDetector(
        onPanUpdate: (details) => setState(() => panOffset += details.delta),
        onPanEnd: (details) => setState(() => panOffset = Offset.zero),
        child: buildMainScreen(context),
      ),
    );
  }

  Widget buildMainScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double dy = math.sin(animation.value) * _kDefaultCircleRadius;
    double dx = math.cos(animation.value) * _kDefaultCircleRadius;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          getRedBox(Offset(size.width / 2 + dx, size.height / 2 + dy)),
          getBlueBox(Offset(size.width / 2 - dx, size.height / 2 - dy)),
          getLittleBox(Offset(size.width / 2 - dx, size.height / 2 - dy)),
        ],
      ),
    );
  }

  Widget getLittleBox(Offset offset) {
    double dx =
        offset.dx + math.sin(animation.value) * _kDefaultCircleRadius / 2;
    double dy =
        offset.dy + math.cos(animation.value) * _kDefaultCircleRadius / 2;
    return Positioned.fromRect(
      rect: Rect.fromCenter(
        center: Offset(dx, dy),
        width: _kDefaultCircleSize / 2,
        height: _kDefaultCircleSize / 2,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200],
              blurRadius: _kBlurRadius / 2,
              spreadRadius: _kSpreadRadius / 2,
            ),
            BoxShadow(color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget getBlueBox(Offset offset) {
    return Positioned.fromRect(
      rect: Rect.fromCenter(
        center: offset,
        width: _kDefaultCircleSize,
        height: _kDefaultCircleSize,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent[200],
              blurRadius: _kBlurRadius,
              spreadRadius: _kSpreadRadius,
            ),
            BoxShadow(color: Colors.cyanAccent),
          ],
        ),
      ),
    );
  }

  Widget getRedBox(Offset offset) {
    return Positioned.fromRect(
      rect: Rect.fromCenter(
        center: offset,
        width: _kDefaultCircleSize,
        height: _kDefaultCircleSize,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.orange[200],
              blurRadius: _kBlurRadius,
              spreadRadius: _kSpreadRadius,
            ),
            BoxShadow(color: Colors.orange),
          ],
        ),
      ),
    );
  }
}
