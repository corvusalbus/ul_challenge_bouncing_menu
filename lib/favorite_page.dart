import 'package:flutter/material.dart';

import 'bouncing_card.dart';

class FavoritePage extends StatelessWidget {
  final double power;
  final double xPosition;
  final AnimationController animationController;
  final double width;
  final double height;
  final Color color;
  final String placeName;
  final String timeAgo;
  final String title;
  const FavoritePage(
      {Key? key,
      required this.power,
      required this.animationController,
      required this.height,
      required this.width,
      required this.color,
      required this.xPosition,
      required this.placeName,
      required this.timeAgo,
      required this.title})
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
            xPosition: xPosition),
        Transform(
          transform: Matrix4.identity()..translate(-xPosition, 0.0),
          //alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  Text(
                    placeName,
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0),
                  ),
                  SizedBox(
                    width: 24.0,
                  )
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Divider(
                          thickness: 3.0,
                          endIndent: 5.0,
                          color: Colors.white24)),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 32.0,
                    child: Text(
                      timeAgo,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                          thickness: 3.0, indent: 5.0, color: Colors.white24)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 120,
                  child: Placeholder(
                    fallbackHeight: 120,
                    fallbackWidth: 120,
                  ),
                ),
              ),
              Text(title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0)),
              SizedBox(width: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: ListTile(
                  leading: CircleAvatar(),
                  title: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              ListTile()
            ],
          ),
        ),
      ],
    );
  }
}
