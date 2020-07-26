import 'dart:math';

import 'package:animationtutorial/src/anim/anim_shadow_box.dart';
import 'package:animationtutorial/src/anim/galaxy.dart';
import 'package:animationtutorial/src/anim/squishy_toggle_button.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AnimationApp());
}

class AnimationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => MainEntry(),
        ...AnimShadowBox.routeNameMap,
        ...SquishyToggle.routeNameMap,
        ...Galaxy.routeNameMap,
      },
    );
  }
}

class MainEntry extends StatefulWidget {
  @override
  _MainEntryState createState() => _MainEntryState();
}

class _MainEntryState extends State<MainEntry> {
  static final List<String> kRoutes = [
    AnimShadowBox.routeNameMap.keys.first,
    SquishyToggle.routeNameMap.keys.first,
    Galaxy.routeNameMap.keys.first,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              floating: false,
              pinned: true,
              snap: false,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Anim Collections'),
                background: Image.network(
                  'https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=380&w=640',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (_, index) => ListTile(
            title: Text(kRoutes[index].replaceAll('/', '')),
            onTap: () => Navigator.pushNamed(context, kRoutes[index]),
          ),
          itemCount: kRoutes.length,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}

class HomeEntry extends StatefulWidget {
  @override
  _HomeEntryState createState() => _HomeEntryState();
}

const double _kPageHeight = 100;

class _HomeEntryState extends State<HomeEntry>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  PageController _pageController;
  double _curPage = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _curPage = _pageController.page;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
      ),
      body: Center(
        child: SizedBox(
          height: _kPageHeight,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                height: _kPageHeight,
                alignment: Alignment.center,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.006)
                    ..rotateX(pi * 0.5 * (_curPage - index))
                    ..setTranslationRaw(0, 50 * (_curPage - index), 0),
                  child: Text(
                    '$index',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.teal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
