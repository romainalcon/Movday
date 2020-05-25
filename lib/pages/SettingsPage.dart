import 'package:Movday/widgets/CustomAppBar.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final double _widthScreen = MediaQuery.of(context).size.width;
    final double _heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        widthScreen: _widthScreen,
        heightScreen: _heightScreen,
        showReturn: true,
        showSettings: false,
      ),
      body: Center(
        child: Text("Settings")
      )
    );
  }
}