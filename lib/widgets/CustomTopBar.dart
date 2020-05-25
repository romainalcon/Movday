import 'package:flutter/material.dart';

class CustomTopBar extends StatelessWidget {
  final BuildContext context;
  final double heightScreen;
  final double widthScreen;
  final double topBarHeight;
  final Widget topBarWidget;

  CustomTopBar({
    @required this.context,
    @required this.heightScreen,
    @required this.widthScreen,
    @required this.topBarHeight,
    @required this.topBarWidget
  });

  @override
  Widget build(BuildContext context) {
    double topHeight = this.heightScreen * this.topBarHeight;
    return new Positioned(
      width: widthScreen,
      child: Container(
        alignment: Alignment.center,
        width: widthScreen,
        height: topHeight,
        color: Colors.white,
        child: this.topBarWidget,
      ),
    );
  }

}