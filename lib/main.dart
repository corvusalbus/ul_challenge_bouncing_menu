import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FavouritePage(),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({
    Key? key,
  }) : super(key: key);
  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(),
      ),
    );
  }
}

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animationController.addListener(() => setState(() {
          if (animationController.value == 1) {
            animationController.reset();
          }
          ;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Scaffold(
            body: Stack(
              children: [
                Column(children: [
                  ElevatedButton(
                    onPressed: () => animationController.forward(),
                    child: Text('Test spring'),
                  ),
                  ElevatedButton(
                    onPressed: () => animationController.reset(),
                    child: Text('reset'),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: constraints.maxWidth,
                        height: constraints.biggest.height,
                        child: CustomPaint(
                          foregroundPainter: SpringPainterVertical(
                              value: animationController.value),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}

class SpringPainterVertical extends CustomPainter {
  final double value;
  final double startedvalue;

  SpringPainterVertical({required this.value});
  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.black;
    final path = Path();
    final controlPointXL = exp(-3 * value) *
        cos(8 * pi * value) *
        startedvalue; // * size.width * 0.5;

    path.moveTo(0.0, 0.0);
    path.quadraticBezierTo(
        -controlPointXL, size.height * 0.5, 0.0, size.height);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(
        -controlPointXL + size.width, size.height * 0.5, size.width, 0.0);
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
