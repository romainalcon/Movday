import 'package:Movday/icons/movday_icons.dart';
import 'package:Movday/librairies/Categories.dart';
import 'package:Movday/librairies/Common.dart';
import 'package:Movday/librairies/Favories.dart';
import 'package:Movday/widgets/CustomSmallButton.dart';
import 'package:Movday/widgets/CustomText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const imgUrl = "https://image.tmdb.org/t/p/w500";

class CustomItemCard extends StatefulWidget {
  final double heightScreen;
  final double widthScreen;
  final GlobalKey<ScaffoldState> scaffoldKey;

  final int movieId;
  final String movieTitle;
  final String movieDate;
  final String movieDescription;
  final String movieImage;
  final double movieScore;
  final List movieCategories;

  final double imageWidth;
  final double imageHeight;
  final double infosWidth;
  final double infosPadding;

  CustomItemCard({
    @required this.heightScreen,
    @required this.widthScreen,
    @required this.scaffoldKey,
    @required this.movieId,
    @required this.movieTitle,
    @required this.movieDate,
    @required this.movieDescription,
    @required this.movieImage,
    @required this.movieScore,
    @required this.movieCategories,
    this.imageWidth = 1.5,
    this.imageHeight = 0.2,
    this.infosWidth = 0.7,
    this.infosPadding = 0.01
  });

  @override
  _CustomItemCard createState() => new _CustomItemCard();

}

class _CustomItemCard extends State<CustomItemCard> {
  bool _isFavorite = false;
  Categories categories = Categories();
  Favories favories = Favories();
  
  bool _showDescription = false;
  int _numberLinesDescription = 1;

  String _categoriesString = "";

  GlobalKey _containerInfosKey = new GlobalKey();
  GlobalKey _bottomInfosKey = new GlobalKey();
  GlobalKey _topInfosKey = new GlobalKey();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didUpdateWidget(CustomItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _categoriesString = categories.getNameArrayCategorie(widget.movieCategories);
    });
    favories.testFavory(widget.movieId).then((isFav) {
      setState(() {
        _isFavorite = isFav;
      });
    });
  }

  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await categories.initCategories(context);
      await favories.initTable();

      bool isFav = await favories.testFavory(widget.movieId);

      setState(() {
        _numberLinesDescription = calculateNumberLinesDescription();
        _showDescription = true;
        _categoriesString = categories.getNameArrayCategorie(widget.movieCategories);
        _isFavorite = isFav;
      });
    });
  }

  Size getSizes(GlobalKey key) {
    if (key.currentContext != null) {
      final RenderBox render = key.currentContext.findRenderObject();
      final size = render.size;
      return size;
    } else {
      return Size.zero;
    }
  }

  int calculateNumberLinesDescription() {
    double totalHeight = getSizes(_containerInfosKey).height;
    double topHeight = getSizes(_topInfosKey).height;
    double bottomHeight = getSizes(_bottomInfosKey).height;

    double restHeight = totalHeight - (topHeight + bottomHeight);

    return (restHeight / 20).floor();
  }

  Future clickOnFavoriteButton() async {
    if (_isFavorite) {
      await removeMovieToFavories();
    } else {
      await addMovieToFavories();
    }
  }

  Future addMovieToFavories() async {
    await favories.addFavory(widget.scaffoldKey, widget.movieId, {
      "movieTitle": widget.movieTitle,
      "movieDate": widget.movieDate,
      "movieDescription": widget.movieDescription,
      "movieImage": widget.movieImage,
      "movieScore": widget.movieScore,
      "movieCategories": widget.movieCategories,
    });
    setState(() {
      _isFavorite = true;
    });
  }

  Future removeMovieToFavories() async {
    await favories.removeFavory(widget.scaffoldKey, widget.movieId);
    setState(() {
      _isFavorite = false;
    });
  }

  Widget moviePoster() {
    double imageHeight = widget.heightScreen * widget.imageHeight;
    double imageWidth = imageHeight / widget.imageWidth;

    return GestureDetector(
      child: CachedNetworkImage(
        imageUrl: imgUrl + widget.movieImage,
        height: imageHeight,
        width: imageWidth,
        fit: BoxFit.fill,
        placeholder: (context, url) => new Container(
          height: imageHeight,
          width: imageWidth,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, "/movie", arguments: {"movieId": widget.movieId});
      },
    );
  }

  Widget topMovieInfos() {
    return Column(
      key: _topInfosKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomText(
          text: widget.movieTitle,
          fontColor: FontColor.dark,
          fontWeight: FontWeight.bold,
          fontSize: FontSize.xl,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CustomText(
              text: "Date : ",
              fontColor: FontColor.grey,
              fontSize: FontSize.md,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: formatDateWithLocale(widget.movieDate),
              fontColor: FontColor.grey,
              fontSize: FontSize.md,
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 3),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CustomText(
              text: "Genre : ",
              fontColor: FontColor.grey,
              fontSize: FontSize.md,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: _categoriesString,
              fontColor: FontColor.grey,
              fontSize: FontSize.md,
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 3),
        ),
        Visibility(
          visible: _showDescription,
          child: CustomText(
            text: widget.movieDescription,
            fontSize: FontSize.sm,
            fontColor: FontColor.grey,
            maxLines: _numberLinesDescription,
          ),
        )
      ],
    );
  }

  Widget bottomMovieInfos() {
    var bgFavoryColor = (_isFavorite ? Theme.of(context).primaryColor : Colors.transparent);
    var fontFavoryColor = (_isFavorite ? FontColor.white : FontColor.blue);
    var typeFavoryIcon = (_isFavorite ? Movday.fire_1: Movday.plus);

    return Row(
      key: _bottomInfosKey,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        CustomSmallButton(
          text: "Voir",
          backgroundColor: Theme.of(context).primaryColor,
          fontColor: FontColor.white,
          borderColor: Theme.of(context).primaryColor,
          onPressed: () {
            return Navigator.pushNamed(context, "/movie", arguments: {"movieId": widget.movieId});
          },
        ),
        Padding(padding: EdgeInsets.only(right: 5)),
        CustomSmallButton(
          text: "Favori  ",
          backgroundColor: bgFavoryColor,
          fontColor: fontFavoryColor,
          borderColor: Theme.of(context).primaryColor,
          icon: typeFavoryIcon,
          onPressed: clickOnFavoriteButton,
        ),
        Padding(
          padding: EdgeInsets.only(right: 5),
        ),
        CustomText(
          text: widget.movieScore.toString() + "/10",
          fontColor: FontColor.grey,
          fontSize: FontSize.sm,
          fontWeight: FontWeight.bold,
        )
      ],
    );
  }

  Widget movieInfos() {
    return Expanded(
      child: Container(
        key: _containerInfosKey,
        padding: EdgeInsets.all(widget.infosPadding * widget.widthScreen),
        height: widget.imageHeight * widget.heightScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            topMovieInfos(),
            bottomMovieInfos()
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      width: widget.widthScreen,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          moviePoster(),
          movieInfos()
        ],
      ),
    );
  }

}