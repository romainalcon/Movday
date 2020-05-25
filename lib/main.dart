import 'dart:convert';
import 'package:Movday/pages/FavoritePage.dart';
import 'package:Movday/pages/HomePage.dart';
import 'package:Movday/pages/MoviePage.dart';
import 'package:Movday/pages/SearchPage.dart';
import 'package:Movday/pages/SettingsPage.dart';
import 'package:Movday/pages/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:load/load.dart';
import 'package:loading/indicator/line_scale_indicator.dart';
import 'package:loading/loading.dart';
import 'package:page_transition/page_transition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(
      LoadingProvider(
        loadingWidgetBuilder: (ctx, data) {
          return Center(
            child: Loading(indicator: LineScaleIndicator(), size: 70.0), 
          );
        },
        child: MyApp(),
      )
    );
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movday',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: Color(0xFF0F4C81),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      onGenerateRoute: (setting) {
        switch (setting.name) {
          case "/":
            return PageTransition(child: SplashPage(), type: PageTransitionType.fade, duration: Duration(milliseconds: 350));
            break;
          case "/home":
            return PageTransition(child: HomePage(), type: PageTransitionType.fade, duration: Duration(milliseconds: 350));
            break;
          case "/search":
            return PageTransition(child: SearchPage(), type: PageTransitionType.fade, duration: Duration(milliseconds: 350));
            break;
          case "/favorite":
            return PageTransition(child: FavoritePage(), type: PageTransitionType.fade, duration: Duration(milliseconds: 350));
            break;
          case "/settings":
            return PageTransition(child: SettingsPage(), type: PageTransitionType.fade, duration: Duration(milliseconds: 350));
            break;
          case "/movie":
            return PageTransition(child: MoviePage(movieId: getParameters(setting.arguments, 'movieId')), type: PageTransitionType.fade, duration: Duration(milliseconds: 350));
          default:
            return null;
        }
      },
    );
  }
}

dynamic getParameters(Object arguments, String name) {
  return json.decode(JsonEncoder().convert(arguments))[name];
}
