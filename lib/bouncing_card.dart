import 'dart:math';

import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 60.0),
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
