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
    animationController.addListener(() => setState(() {}));
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
                LayoutBuilder(
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
                )
              ],
            ),
          );
        });
  }
}

class SpringPainterVertical extends CustomPainter {
  final double value;

  SpringPainterVertical({required this.value});
  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.black;
    final path = Path();
    // final startPointXL =
    //     (size.width *0.5) ;
    final x0 = (size.width * 0.5);
    //final controlPointXL = x0 * cos(20 * value) + 1 * sin(20 * value);
    final controlPointXL = exp(-3 * value) * cos(6 * pi * value) * size.width;
    // final endPointXL =
    //     (size.width * (0.5 + 0.5 * x3)) - size.height * thickness * 0.5;
    final amplitude = sqrt(x0 * x0 + 1);

    path.moveTo(size.width * 0.5, 0.0);
    path.quadraticBezierTo(-controlPointXL + size.width * 0.5,
        size.height * 0.5, size.width * 0.5, size.height);
    print(controlPointXL);
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
