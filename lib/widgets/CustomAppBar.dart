import 'package:Movday/icons/movday_icons.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final double heightScreen;
  final double widthScreen;
  final double appBarHeight;
  final double appBarWidth;
  final double appBarLogoHeight;
  final double appBarIconHeight;
  final bool showReturn;
  final bool showSettings;

  CustomAppBar({
    @required this.context,
    @required this.heightScreen,
    @required this.widthScreen,
    this.appBarHeight = 0.07,
    this.appBarWidth = 1,
    this.appBarLogoHeight = 0.035,
    this.appBarIconHeight = 0.025,
    this.showReturn = false,
    this.showSettings = true
  });

  @override
  Widget build(BuildContext context) {
    double logoSize = this.heightScreen * this.appBarLogoHeight;
    double iconSize = this.heightScreen * this.appBarIconHeight;
    Widget leading;
    List<Widget> settings = [];

    if (showReturn) {
      leading = IconButton(
        iconSize: iconSize,
        icon: Icon(Movday.arrow_left),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      leading = null;
    }

    if (showSettings) {
      settings.add(IconButton(
        iconSize: iconSize,
        icon: Icon(Movday.cog),
        onPressed: () {
          Navigator.pushNamed(context, "/settings");
        },
      ));
    }

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: leading,
      title: Image.asset(
        "assets/images/logo_long_white.png",
        height: logoSize,
      ),
      actions: settings,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Size get preferredSize => Size(widthScreen * appBarWidth, heightScreen * appBarHeight);

}