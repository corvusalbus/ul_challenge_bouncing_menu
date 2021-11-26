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
  double power = 1;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animationController.addListener(() => setState(() {
          if (animationController.value == 1) {
            animationController.reset();
            power = 1;
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            return Scaffold(
              body: Stack(
                children: [
                  Column(children: [
                    SizedBox(height: 40.0),
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
                      return BouncingCard(
                        power: power,
                        animationController: animationController,
                        height: constraints.maxHeight,
                        width: constraints.biggest.width,
                        color: Colors.black,
                        xPosition: power,
                      );
                    },
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return BouncingCard(
                        color: Colors.red,
                        power: power,
                        animationController: animationController,
                        height: constraints.maxHeight,
                        width: constraints.biggest.width,
                        xPosition: power - constraints.biggest.width,
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }

  void _handleDragEnd(DragEndDetails details) {
    print('end');
    animationController.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta != null) {
      if (details.primaryDelta! > 0.0) {
        power += details.primaryDelta!;
        // / 250;
      }
      if (details.primaryDelta! < 0.0) {
        power -= details.primaryDelta!; // / 250;
      }
      setState(() {});
      print('power $power');
    }
    print('power $power');
  }
}

class BouncingCard extends StatelessWidget {
  const BouncingCard(
      {Key? key,
      required this.power,
      required this.animationController,
      required this.height,
      required this.width,
      required this.color,
      required this.xPosition})
      : super(key: key);

  final double power;
  final double xPosition;
  final AnimationController animationController;
//  final BoxConstraints constraints;
  final double width;
  final double height;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()..translate(-xPosition, 0.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 120.0),
        child: Container(
          width: width,
          height: height,
          child: CustomPaint(
            foregroundPainter: SpringPainterVertical(
                startedvalue: power,
                value: animationController.value,
                color: color),
          ),
        ),
      ),
    );
  }
}

class SpringPainterVertical extends CustomPainter {
  final double value;
  final double startedvalue;
  final Color color;

  SpringPainterVertical(
      {required this.color, required this.startedvalue, required this.value});
  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = color;
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
