import 'package:flutter/material.dart';

class AnimShadowBox extends StatefulWidget {
  static Map<String, WidgetBuilder> routeNameMap = {
    "/AnimShadowBox": (context) => AnimShadowBox()
  };

  @override
  _AnimShadowBoxState createState() => _AnimShadowBoxState();
}

class _AnimShadowBoxState extends State<AnimShadowBox>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = Tween(begin: 4.0, end: 36.0).animate(animationController);
    animationController.addListener(() {
      setState(() {});
    });
    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.pinkAccent),
            boxShadow: [
              BoxShadow(
                color: Colors.pinkAccent,
                blurRadius: animation.value,
                spreadRadius: 2.0,
              ),
            ],
          ),
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
