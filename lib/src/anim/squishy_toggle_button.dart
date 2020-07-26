import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// WIP

const _kBoxSize = 140.0;
const _kMargin = 22.0;
const _kIconSize = 42.0;
const _kDefaultColor = Color(0xFFCCD0D4);

class SquishyToggle extends StatefulWidget {
  static Map<String, WidgetBuilder> routeNameMap = {
    "/SquishyToggle": (context) => SquishyToggle()
  };

  @override
  _SquishyToggleState createState() => _SquishyToggleState();
}

class _SquishyToggleState extends State<SquishyToggle> {
  bool addChecked = false;
  bool removeChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(Icons.add, () {
              setState(() {
                addChecked = !addChecked;
              });
            }),
            SizedBox(height: 24),
            buildButton(Icons.remove, () {
              setState(() {
                removeChecked = !removeChecked;
              });
            }),
          ],
        ),
      ),
    );
  }

  //0 15px 25px -4px rgba(0, 0, 0, 0.5),
  // inset 0 -3px 4px -1px rgba(0, 0, 0, 0.2),
  // 0 -10px 15px -1px rgba(255, 255, 255, 0.6),
  // inset 0 3px 4px -1px rgba(255, 255, 255, 0.2),
  // inset 0 0 5px 1px rgba(255, 255, 255, 0.8),
  // inset 0 20px 30px 0 rgba(255, 255, 255, 0.2)
  List<BoxShadow> getNormalShadowList() {
    return [
      BoxShadow(
        offset: Offset(0, 15),
        blurRadius: 25,
        spreadRadius: -4,
        color: Colors.black.withOpacity(0.5),
      ),
      BoxShadow(
        offset: Offset(0, -3),
        blurRadius: 4,
        spreadRadius: -1,
        color: Colors.black.withOpacity(0.2),
      ),
      BoxShadow(
        offset: Offset(0, -10),
        blurRadius: 15,
        spreadRadius: -1,
        color: Colors.white.withOpacity(0.6),
      ),
      BoxShadow(
        offset: Offset(0, 3),
        blurRadius: 4,
        spreadRadius: -1,
        color: Colors.white.withOpacity(0.2),
      ),
      BoxShadow(
        blurRadius: 5,
        spreadRadius: 1,
        color: Colors.white.withOpacity(0.8),
      ),
      BoxShadow(
        offset: Offset(0, 20),
        blurRadius: 30,
        color: Colors.white.withOpacity(0.2),
      ),
    ];
  }

  //0 15px 25px -4px rgba(0, 0, 0, 0.4),
  // inset 0 -8px 25px -1px rgba(255, 255, 255, 0.9),
  // 0 -10px 15px -1px rgba(255, 255, 255, 0.6),
  // inset 0 8px 20px 0 rgba(0, 0, 0, 0.2),
  // inset 0 0 5px 1px rgba(255, 255, 255, 0.6)
  List<BoxShadow> getCheckedShadowList() {
    return [
      BoxShadow(
        offset: Offset(0, 15),
        blurRadius: 25,
        spreadRadius: -4,
        color: Colors.black.withOpacity(0.4),
      ),
      BoxShadow(
        offset: Offset(0, -8),
        blurRadius: 25,
        spreadRadius: -1,
        color: Colors.white.withOpacity(0.9),
      ),
      BoxShadow(
        offset: Offset(0, -10),
        blurRadius: 15,
        spreadRadius: -1,
        color: Colors.white.withOpacity(0.6),
      ),
      BoxShadow(
        offset: Offset(0, 8),
        blurRadius: 20,
        color: Colors.black.withOpacity(0.2),
      ),
      BoxShadow(
        blurRadius: 5,
        spreadRadius: 1,
        color: Colors.white.withOpacity(0.6),
      ),
    ];
  }

  //inset 0 0 35px 5px rgba(0, 0, 0, 0.25),
  // inset 0 2px 1px 1px rgba(255, 255, 255, 0.9),
  // inset 0 -2px 1px 0 rgba(0, 0, 0, 0.25)
  Decoration getRectangleDecoration() {
    return BoxDecoration(
      shape: BoxShape.rectangle,
      color: _kDefaultColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Colors.white.withOpacity(0.25),
      ),
      boxShadow: [
        BoxShadow(
          blurRadius: 35,
          spreadRadius: 5,
          color: Colors.black.withOpacity(0.25),
        ),
        BoxShadow(
          offset: Offset(0, 2),
          blurRadius: 1,
          spreadRadius: 1,
          color: Colors.white.withOpacity(0.9),
        ),
        BoxShadow(
          offset: Offset(0, -2),
          blurRadius: 1,
          color: Colors.black.withOpacity(0.25),
        ),
      ],
    );
  }

  Widget getCircle(IconData iconData) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Cubic(0.23, 1, 0.32, 1),
      alignment: Alignment.center,
      margin: EdgeInsets.all(_kMargin),
      child: Opacity(
        opacity: 0.9,
        child: Icon(
          iconData,
          size: _kIconSize,
          color: Colors.black.withOpacity(0.4),
        ),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _kDefaultColor,
        boxShadow: addChecked ? getCheckedShadowList() : getNormalShadowList(),
      ),
    );
  }

  Widget buildButton(IconData iconData, Function click) {
    return GestureDetector(
      onTap: click,
      child: Container(
        width: _kBoxSize,
        height: _kBoxSize,
        child: getCircle(iconData),
        decoration: getRectangleDecoration(),
      ),
    );
  }
}

class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    Key key,
    this.color,
    this.blur,
    this.offset,
    Widget child,
  }) : super(key: key, child: child);

  final Color color;
  final double blur;
  final Offset offset;

  @override
  RenderInnerShadow createRenderObject(BuildContext context) {
    return RenderInnerShadow()
      ..color = color
      ..blur = blur
      ..offset = offset;
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderInnerShadow renderObject) {
    renderObject
      ..color = color
      ..blur = blur
      ..offset = offset;
  }
}

class RenderInnerShadow extends RenderProxyBox {
  RenderInnerShadow({
    RenderBox child,
  }) : super(child);

  @override
  bool get alwaysNeedsCompositing => child != null;

  Color _color;
  double _blur;
  Offset _offset;

  Color get color => _color;

  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  double get blur => _blur;

  set blur(double value) {
    if (_blur == value) return;
    _blur = value;
    markNeedsPaint();
  }

  Offset get offset => _offset;

  set offset(Offset value) {
    if (_offset == value) return;
    _offset = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      var layerPaint = Paint()..color = Colors.white;

      var canvas = context.canvas;
      canvas.saveLayer(offset & size, layerPaint);
      context.paintChild(child, offset);
      var shadowPaint = Paint()
        ..blendMode = ui.BlendMode.srcATop
        ..imageFilter = ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur)
        ..colorFilter = ui.ColorFilter.mode(color, ui.BlendMode.srcIn);
      canvas.saveLayer(offset & size, shadowPaint);

      // Invert the alpha to compute inner part.
      var invertPaint = Paint()
        ..colorFilter = const ui.ColorFilter.matrix([
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          -1,
          255,
        ]);
      canvas.saveLayer(offset & size, invertPaint);
      canvas.translate(_offset.dx, _offset.dy);
      context.paintChild(child, offset);
      context.canvas.restore();
      context.canvas.restore();
      context.canvas.restore();
    }
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    if (child != null) visitor(child);
  }
}
