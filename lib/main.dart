import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ul_challenge_bouncing_menu/bouncing_card.dart';

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
        primarySwatch: Colors.deepPurple,
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
  Power power = Power(maxValue: 100);

  int indexActive = 0;

  @override
  void initState() {
    super.initState();
    animationControllerBounce =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animationControllerBounce.addListener(() => setState(() {
          if (animationControllerBounce.isCompleted) {
            animationControllerBounce.reset();
            power.resetPower();
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
                          appBar: AppBar(
                            title: Text('Favorite'),
                          ),
                          backgroundColor: Colors.deepPurple[900],
                          body: Stack(
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return FavoritePage(
                                    power: power.value,
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
                                  return FavoritePage(
                                    color: Colors.red,
                                    power: power.value,
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
                                  return FavoritePage(
                                    color: Colors.green,
                                    power: power.value,
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
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return FavoritePage(
                                    color: Colors.pink,
                                    power: power.value,
                                    animationController:
                                        animationControllerBounce,
                                    height: constraints.maxHeight,
                                    width: constraints.biggest.width,
                                    xPosition: (animationControllerSlide.value -
                                                animationControllerSlideReverse
                                                    .value) *
                                            constraints.biggest.width +
                                        (indexActive - 3) *
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
        power.addPower(-details.primaryDelta!);
      }
      if (details.primaryDelta! > 0.0) {
        animationControllerSlideReverse.value += details.primaryDelta! / 250;
        power.addPower(-details.primaryDelta!); // / 250;
      }
      setState(() {});
      // print('power $power');
    }
    //print('power $power');
  }
}

class FavoritePage extends StatelessWidget {
  final double power;
  final double xPosition;
  final AnimationController animationController;
  final double width;
  final double height;
  final Color color;
  const FavoritePage(
      {Key? key,
      required this.power,
      required this.animationController,
      required this.height,
      required this.width,
      required this.color,
      required this.xPosition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BouncingCard(
            power: power,
            animationController: animationController,
            height: height,
            width: width,
            color: color,
            xPosition: xPosition)
      ],
    );
  }
}

class Power {
  double value = 1;
  final double maxValue;
  Power({required this.maxValue});

  void addPower(double addPower) {
    final tmpPower = value + addPower;
    if (tmpPower > maxValue) {
      value = maxValue;
    } else if (tmpPower < -maxValue) {
      value = -maxValue;
    } else {
      value = tmpPower;
    }
  }

  void resetPower() {
    value = 1;
  }
}
