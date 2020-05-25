import 'package:Movday/icons/movday_icons.dart';
import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final BuildContext context;
  final double widthScreen;
  final double heightScreen;
  final double bottomBarHeight;
  final double bottomBarWidth;
  final double bottomBarIconHeight;
  final double bottomBarBorderHeight;

  CustomBottomBar({
    @required this.context,
    @required this.widthScreen,
    @required this.heightScreen,
    this.bottomBarHeight = 0.08,
    this.bottomBarWidth = 1,
    this.bottomBarIconHeight = 0.028,
    this.bottomBarBorderHeight = 0.0005
  });

  @override
  Widget build(BuildContext context) {
    double iconSize = this.heightScreen * this.bottomBarIconHeight;

    return Container(
      height: this.heightScreen * this.bottomBarHeight,
      width: this.widthScreen * this.bottomBarWidth,
      color: Theme.of(context).primaryColor,
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          IconButton(
            iconSize: iconSize,
            icon: Icon(Movday.fire_1),
            color: Colors.white,
            onPressed: () {
              Navigator.popUntil(context, (route) {
                if (route.settings.name != "/home") {
                  Navigator.pushReplacementNamed(context, "/home");
                }
                return true;
              });
            },
          ),
          IconButton(
            iconSize: iconSize,
            icon: Icon(Movday.search),
            color: Colors.white,
            onPressed: () {
              Navigator.popUntil(context, (route) {
                if (route.settings.name != "/search") {
                  Navigator.pushReplacementNamed(context, "/search");
                }
                return true;
              });
            },
          ),
          IconButton(
            iconSize: iconSize,
            icon: Icon(Movday.favorite),
            color: Colors.white,
            onPressed: () {
              Navigator.popUntil(context, (route) {
                if (route.settings.name != "/favorite") {
                  Navigator.pushReplacementNamed(context, "/favorite");
                }
                return true;
              });
            },
          ),
        ],
      ),  
    );
  }

}