import 'dart:convert';
import 'package:Movday/librairies/Favories.dart';
import 'package:Movday/widgets/CustomAppBar.dart';
import 'package:Movday/widgets/CustomBottomBar.dart';
import 'package:Movday/widgets/CustomItemCard.dart';
import 'package:Movday/widgets/CustomScrollView.dart' as UpdateScrollView;
import 'package:Movday/widgets/CustomSeparator.dart';
import 'package:Movday/widgets/CustomText.dart';
import 'package:Movday/widgets/CustomTopBar.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> favoriesListMovies = [];
  Favories favories = Favories();

  final double topBarHeightPercent = 0.06;

  Future<void> getFavories() async {
    List listFavories = await favories.getFavories();
    listFavories = listFavories.reversed.toList();
    var listMovie = generateMoviesPreviewFromSQFList(listFavories);

    if (!mounted) return false;

    setState(() {
      favoriesListMovies = listMovie;
    });
  }

  List<Widget> generateMoviesPreviewFromSQFList(List<dynamic> list) {
    List<Widget> listMovies = [];
    final double _widthScreen = MediaQuery.of(context).size.width;
    final double _heightScreen = MediaQuery.of(context).size.height;

    for (var i = 0; i < list.length; i++) {
      listMovies.add(CustomItemCard(
        scaffoldKey: _scaffoldKey,
        widthScreen: _widthScreen,
        heightScreen: _heightScreen,
        movieId: list[i]['movieId'],
        movieTitle: list[i]['movieTitle'],
        movieDate: list[i]['movieDate'],
        movieDescription: list[i]['movieDescription'],
        movieImage: list[i]['movieImage'],
        movieScore: list[i]['movieScore'].toDouble(),
        movieCategories: json.decode(list[i]['movieCategories']),
      ));
      listMovies.add(CustomSeparator(
        screenHeight: _heightScreen,
        screenWidth: _widthScreen,
        backgroundColor: Colors.grey[300]
      ));
    }

    return listMovies;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await favories.initTable();
      await getFavories();
    });
  }

  Widget constructTopBar(heightScreen, widthScreen) {
    return new CustomTopBar(
      context: context,
      heightScreen: heightScreen,
      widthScreen: widthScreen,
      topBarHeight: topBarHeightPercent,
      topBarWidget: CustomText(
        text: "Vos favoris",
        fontColor: FontColor.blue,
        fontSize: FontSize.xl,
        fontWeight: FontWeight.bold,
      )
    );
  }

  Widget contentBar(_widthScreen, _heightScreen) {
    if (favoriesListMovies.length == 0) {
      return Center(
        child: CustomText(
          text: "Vous n'avez pas de favoris",
          fontColor: FontColor.grey,
          fontSize: FontSize.xl
        ),
      );
    } else {
      return Container(
        width: _widthScreen,
        color: Colors.transparent,
        padding: EdgeInsets.only(top: _heightScreen * topBarHeightPercent),
        child: UpdateScrollView.CustomScrollView(
          updateMethode: () async {
            await getFavories();
          },
          listWidget: favoriesListMovies,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _widthScreen = MediaQuery.of(context).size.width;
    final double _heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        context: context,
        widthScreen: _widthScreen,
        heightScreen: _heightScreen,
      ),
      bottomNavigationBar: CustomBottomBar(
        context: context,
        widthScreen: _widthScreen,
        heightScreen: _heightScreen,
      ),
      body: new Stack(
        children: <Widget>[
          constructTopBar(_heightScreen, _widthScreen),
          contentBar(_widthScreen, _heightScreen)
        ],
      )
    );
  }
}