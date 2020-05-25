import 'package:Movday/icons/movday_icons.dart';
import 'package:Movday/librairies/Categories.dart';
import 'package:Movday/librairies/Common.dart';
import 'package:Movday/librairies/Favories.dart';
import 'package:Movday/librairies/Request.dart';
import 'package:Movday/widgets/CustomAppBar.dart';
import 'package:Movday/widgets/CustomBottomBar.dart';
import 'package:Movday/widgets/CustomSeparator.dart';
import 'package:Movday/widgets/CustomSmallButton.dart';
import 'package:Movday/widgets/CustomText.dart';
import 'package:Movday/widgets/CustomTopBar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';

class MoviePage extends StatefulWidget {
  final int movieId;

  MoviePage({
    @required this.movieId
  });

  @override
  _MoviePageState createState() => _MoviePageState();
}

const imagePrefix = "https://image.tmdb.org/t/p/w500";

class _MoviePageState extends State<MoviePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final double topBarHeightPercent = 0.06;
  bool isMovieLoaded = false;
  bool _isFavorite = false;

  var categories = Categories();
  var favories = Favories();

  String _moviePosterUrl = "";
  String _movieReleaseDate = "";
  List _movieCategories = [];
  int _movieDuration;
  List _movieNationalities = [];
  String _movieTitle = "";
  double _movieScore;
  String _movieOverview = "";

  Future clickOnFavoriteButton() async {
    if (_isFavorite) {
      await removeMovieToFavories();
    } else {
      await addMovieToFavories();
    }
  }

  Future addMovieToFavories() async {
    List cleanCategoriesList = [];
    for (var i = 0; i < _movieCategories.length; i++) {
      cleanCategoriesList.add(_movieCategories[i]["id"]);
    }

    await favories.addFavory(_scaffoldKey, widget.movieId, {
      "movieTitle": _movieTitle,
      "movieDate": _movieReleaseDate,
      "movieDescription": _movieOverview,
      "movieImage": _moviePosterUrl,
      "movieScore": _movieScore,
      "movieCategories": cleanCategoriesList,
    });
    setState(() {
      _isFavorite = true;
    });
  }

  Future removeMovieToFavories() async {
    await favories.removeFavory(_scaffoldKey, widget.movieId);
    setState(() {
      _isFavorite = false;
    });
  }

  getMovieInfos() async {
    showLoadingDialog();

    var response = await fetchPost(RequestType.get, "/movie/" + widget.movieId.toString(), {});

    if (response.status == 200) {
      if (response.body['title'] == null || response.body['title'].length == 0) return false;
      if (response.body['release_date'] == null || response.body['release_date'].length == 0) return false;
      if (response.body['overview'] == null || response.body['overview'].length == 0) return false;
      if (response.body['poster_path'] == null || response.body['poster_path'].length == 0) return false;
      if (response.body['vote_average'] == null) return false;
      if (response.body['genres'] == null) return false;

      if (!mounted) return false;

      setState(() {
        _movieTitle = response.body['title'];
        _moviePosterUrl = response.body['poster_path'];
        _movieReleaseDate = response.body['release_date'];
        _movieOverview = response.body['overview'];
        _movieScore = response.body['vote_average'];
        _movieCategories = response.body['genres'];
        _movieDuration = response.body['runtime'];
        _movieNationalities = response.body['production_countries'];
        isMovieLoaded = true;
      });
    }

    hideLoadingDialog();
  }

  Widget buildTopMovieWidget(widthScreen, heightScreen) {
    double imageWidth = widthScreen / 2;
    double imageHeight = imageWidth * 1.5;
    Widget posterMovie;
    String movieDate = "";
    String movieDuration = "";
    String movieCategories = "";
    String movieNationalities = "";

    if (!isMovieLoaded) {
      posterMovie = Container(
        width: imageWidth,
        height: imageHeight,
        color: Theme.of(context).primaryColor,
      );
    } else {
      posterMovie = CachedNetworkImage(
        imageUrl: imagePrefix + _moviePosterUrl,
        height: imageHeight,
        width: imageWidth,
        fit: BoxFit.fill,
        placeholder: (context, url) => new Container(
          width: imageWidth,
          height: imageHeight,
          color: Theme.of(context).primaryColor,
        ),
      );

      movieDate = formatDateWithLocale(_movieReleaseDate);

      int movieHour = _movieDuration ~/ 60;
      int movieMinute = _movieDuration - movieHour * 60;
      movieDuration = movieHour.toString() + "h" + movieMinute.toString().padLeft(2, '0');

      List<int> movieCategoriesInt = [];
      for (var i = 0; i < _movieCategories.length; i++) {
        movieCategoriesInt.add(_movieCategories[i]["id"]);
      }
      movieCategories = categories.getNameArrayCategorie(movieCategoriesInt);

      List<String> movieNationalitiesArray = [];
      for (var i = 0; i < _movieNationalities.length; i++) {
        movieNationalitiesArray.add(_movieNationalities[i]["iso_3166_1"]);
      }
      movieNationalities = movieNationalitiesArray.join(", ");
    }

    return Container(
      width: widthScreen,
      child: Row(
        children: <Widget>[
          posterMovie,
          Container(
            width: imageWidth,
            height: imageHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildStandardTopText("Date de sortie", imageHeight, false),
                buildStandardTopText(movieDate, imageHeight, true),
                buildStandardTopText("Genre", imageHeight, false),
                buildStandardTopText(movieCategories, imageHeight, true),
                buildStandardTopText("Durée", imageHeight, false),
                buildStandardTopText(movieDuration, imageHeight, true),
                buildStandardTopText("Origine", imageHeight, false),
                buildStandardTopText(movieNationalities, imageHeight, true)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildStandardTopText(String str, double imageHeight, bool isInfos) {
    return Padding(
      padding: (isInfos ? EdgeInsets.only(bottom: imageHeight * 0.06) : EdgeInsets.only(bottom: imageHeight * 0.01)),
      child: CustomText(
        text: str,
        fontColor: FontColor.grey,
        fontSize: FontSize.md,
        fontWeight: (isInfos ? FontWeight.normal : FontWeight.bold)
      ),
    );
  }

  Widget buildBottomMovieWidget(widthScreen, heightScreen) {
    String movieScore = "Note : ";
    if (isMovieLoaded) {
      movieScore += _movieScore.toString() + "/10";
    }

    EdgeInsets paddingContainer = EdgeInsets.symmetric(
      vertical: heightScreen * 0.015,
      horizontal: heightScreen * 0.01
    );

    return Container(
      width: widthScreen,
      child: Column(
        children: <Widget>[
          CustomSeparator(screenWidth: widthScreen, screenHeight: heightScreen, backgroundColor: Colors.grey[300]),
          Container(
            width: widthScreen,
            padding: paddingContainer,
            child: CustomText(
              text: _movieTitle,
              fontColor: FontColor.dark,
              fontSize: FontSize.xl,
              fontWeight: FontWeight.bold,
              align: TextAlign.center,
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            width: widthScreen,
            padding: paddingContainer,
            child: buildScoreBar(movieScore, heightScreen, widthScreen),
          ),
          Container(
            width: widthScreen,
            padding: paddingContainer,
            child: CustomText(
              text: _movieOverview,
              fontColor: FontColor.dark,
              fontSize: FontSize.md,
              maxLines: 100,
            ),
          )
        ],
      ),
    );
  }

  Widget buildScoreBar(movieScore, heightScreen, widthScreen) {
    var bgFavoryColor = (_isFavorite ? Colors.white : Theme.of(context).primaryColor);
    var fontFavoryColor = (_isFavorite ? FontColor.blue : FontColor.white );
    var typeFavoryIcon = (_isFavorite ? Movday.fire_1: Movday.plus);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomText(
          text: movieScore,
          fontColor: FontColor.white,
          fontSize: FontSize.lg,
          fontWeight: FontWeight.bold,
        ),
        CustomSmallButton(
          text: "Favori  ",
          backgroundColor: bgFavoryColor,
          fontColor: fontFavoryColor,
          borderColor: Colors.white,
          icon: typeFavoryIcon,
          onPressed: clickOnFavoriteButton,
        )
      ],
    );
  }

  Widget constructTopBar(heightScreen, widthScreen) {
    return new CustomTopBar(
      context: context,
      widthScreen: widthScreen,
      heightScreen: heightScreen,
      topBarHeight: topBarHeightPercent,
      topBarWidget: CustomText(
        text: "Votre film",
        fontColor: FontColor.blue,
        fontSize: FontSize.md,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getMovieInfos();
      await categories.initCategories(context);
      await favories.initTable();
      bool isFav = await favories.testFavory(widget.movieId);

      setState(() {
        _isFavorite = isFav;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        context: context,
        widthScreen: _screenWidth,
        heightScreen: _screenHeight,
        showReturn: true,
      ),
      bottomNavigationBar: CustomBottomBar(
        context: context,
        widthScreen: _screenWidth,
        heightScreen: _screenHeight,
      ),
      body: new Stack(
        children: <Widget>[
          //constructTopBar(_screenHeight, _screenWidth),
          Padding(
            padding: EdgeInsets.zero,//EdgeInsets.only(top: _screenHeight * topBarHeightPercent),
            child: SingleChildScrollView(
              physics: new ClampingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  buildTopMovieWidget(_screenWidth, _screenHeight),
                  buildBottomMovieWidget(_screenWidth, _screenHeight)
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}