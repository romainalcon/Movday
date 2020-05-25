import 'package:flutter/material.dart';

class CustomSeparator extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final double appScreenHeight;
  final double appScreenWidth;
  final Color backgroundColor;

  CustomSeparator({
    @required this.screenHeight,
    @required this.screenWidth,
    this.appScreenHeight = 0.003,
    this.appScreenWidth = 1,
    this.backgroundColor = Colors.grey
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: this.screenHeight * this.appScreenHeight,
      width: this.screenWidth * this.appScreenWidth,
      color: backgroundColor,
    );
  }

}