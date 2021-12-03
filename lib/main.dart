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
  late AnimationController animationControllerBounce;
  late AnimationController animationControllerSlide;
  late AnimationController animationControllerSlideReverse;
  double power = 1;
  int indexActive = 0;

  @override
  void initState() {
    super.initState();
    animationControllerBounce =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animationControllerBounce.addListener(() => setState(() {
          if (animationControllerBounce.isCompleted == 1) {
            animationControllerBounce.reset();
            power = 1;
          }
        }));

    animationControllerSlide =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    animationControllerSlide.addListener(() => setState(() {
          if (animationControllerSlide.isCompleted) {
            indexActive += 1;
            animationControllerSlide.reset();
          }
        }));

    animationControllerSlideReverse =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    animationControllerSlideReverse.addListener(() => setState(() {
          if (animationControllerSlideReverse.isCompleted) {
            indexActive -= 1;
            animationControllerSlideReverse.reset();
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: AnimatedBuilder(
          animation: animationControllerSlideReverse,
          builder: (context, slidewidget) {
            return AnimatedBuilder(
                animation: animationControllerSlide,
                builder: (context, slidewidget) {
                  return AnimatedBuilder(
                      animation: animationControllerBounce,
                      builder: (context, _) {
                        return Scaffold(
                          body: Stack(
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return BouncingCard(
                                    power: power,
                                    animationController:
                                        animationControllerBounce,
                                    height: constraints.maxHeight,
                                    width: constraints.biggest.width,
                                    color: Colors.black,
                                    xPosition: (animationControllerSlide.value -
                                                animationControllerSlideReverse
                                                    .value) *
                                            constraints.biggest.width +
                                        indexActive * constraints.biggest.width,
                                  );
                                },
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return BouncingCard(
                                    color: Colors.red,
                                    power: power,
                                    animationController:
                                        animationControllerBounce,
                                    height: constraints.maxHeight,
                                    width: constraints.biggest.width,
                                    xPosition: (animationControllerSlide.value -
                                                animationControllerSlideReverse
                                                    .value) *
                                            constraints.biggest.width +
                                        (indexActive - 1) *
                                            constraints.biggest.width,
                                  );
                                },
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return BouncingCard(
                                    color: Colors.green,
                                    power: power,
                                    animationController:
                                        animationControllerBounce,
                                    height: constraints.maxHeight,
                                    width: constraints.biggest.width,
                                    xPosition: (animationControllerSlide.value -
                                                animationControllerSlideReverse
                                                    .value) *
                                            constraints.biggest.width +
                                        (indexActive - 2) *
                                            constraints.biggest.width,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      });
                });
          }),
    );
  }

  void _handleDragEnd(DragEndDetails details) {
    print('end');
    animationControllerBounce.forward();
    if (animationControllerSlide.value > 0.5 &&
        animationControllerSlide.value != 1.0) {
      animationControllerSlide.forward();
    }
    if (animationControllerSlide.value < 0.5 &&
        animationControllerSlide.value != 0.0) {
      animationControllerSlide.reverse();
    }

    if (animationControllerSlideReverse.value > 0.5 &&
        animationControllerSlideReverse.value != 1.0) {
      animationControllerSlideReverse.forward();
    }
    if (animationControllerSlideReverse.value < 0.5 &&
        animationControllerSlideReverse.value != 0.0) {
      animationControllerSlideReverse.reverse();
    }

    // if (animationControllerSlide.value == 0) {
    //   indexActive += 1;
    //   animationControllerSlide.reset();
    // }
    print('indexActive $indexActive');
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta != null) {
      if (details.primaryDelta! < 0.0) {
        animationControllerSlide.value -= details.primaryDelta! / 250;
        power -= details.primaryDelta!;
      }
      if (details.primaryDelta! > 0.0) {
        animationControllerSlideReverse.value += details.primaryDelta! / 250;
        power -= details.primaryDelta!; // / 250;
      }
      setState(() {});
      // print('power $power');
    }
    //print('power $power');
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
