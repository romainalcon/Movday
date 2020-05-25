import 'package:Movday/librairies/Request.dart';
import 'package:Movday/widgets/CustomAppBar.dart';
import 'package:Movday/widgets/CustomBottomBar.dart';
import 'package:Movday/widgets/CustomItemCard.dart';
import 'package:Movday/widgets/CustomScrollView.dart' as UdaptableScrollView;
import 'package:Movday/widgets/CustomSeparator.dart';
import 'package:Movday/widgets/CustomText.dart';
import 'package:Movday/widgets/CustomTopBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  double _widthScreen;
  double _heightScreen;

  List<Widget> trendsListMovies = [];
  List<Widget> discoverListMovies = [];
  String listChoice = "trends";
  CarouselSlider _sliderHome;
  CarouselController buttonCarouselController = new CarouselController();

  ScrollController _trendsController = new ScrollController();
  bool isLoadingTrends = false;

  ScrollController _discoverController = new ScrollController();
  bool isLoadingDiscover = false;

  Map<String, int> _pageCounter = {"trends": 1, "discover": 1};

  final double topBarHeightPercent = 0.06;

  Future<void> getTrends(newList) async {
    if (!isLoadingTrends) {
      isLoadingTrends = true;

      Post response = await fetchPost(RequestType.get, "/trending/movie/day", {"page": _pageCounter['trends'].toString()});

      if (response.status == 200) {
        List<Widget> listMovies = generateListMoviesFromBody(response.body);

        _pageCounter['trends']++;

        if (!mounted) return false;

        setState(() {
          if (newList) {
            trendsListMovies = listMovies;
          } else {
            trendsListMovies = new List.from(trendsListMovies)..addAll(listMovies);
          }
        });
      }

      isLoadingTrends = false;
    }
  }

  Future<void> getDiscover(newList) async {
    if (!isLoadingDiscover) {
      isLoadingDiscover = true;

      Post response = await fetchPost(RequestType.get, "/discover/movie", {"sort_by": "popularity.desc", "page": _pageCounter['discover'].toString()});

      if (response.status == 200) {
        List<Widget> listMovies = generateListMoviesFromBody(response.body);

        _pageCounter['discover']++;

        if (!mounted) return false;

        setState(() {
          if (newList) {
            discoverListMovies = listMovies;
          } else {
            discoverListMovies = new List.from(discoverListMovies)..addAll(listMovies);
          }
        });
      }

      isLoadingDiscover = false;
    }
  }

  List<Widget> generateListMoviesFromBody(body) {
    List<Widget> listMovie = [];

    for (var i = 0; i < body['results'].length; i++) {
      if (body['results'][i]['id'] == null) continue;
      if (body['results'][i]['title'] == null || body['results'][i]['title'].length == 0) continue;
      if (body['results'][i]['release_date'] == null || body['results'][i]['release_date'].length == 0) continue;
      if (body['results'][i]['overview'] == null || body['results'][i]['overview'].length == 0) continue;
      if (body['results'][i]['poster_path'] == null || body['results'][i]['poster_path'].length == 0) continue;
      if (body['results'][i]['vote_average'] == null) continue;
      if (body['results'][i]['genre_ids'] == null) continue;
    
      listMovie.add(CustomItemCard(
        scaffoldKey: _scaffoldKey,
        widthScreen: _widthScreen,
        heightScreen: _heightScreen,
        movieId: body['results'][i]['id'],
        movieTitle: body['results'][i]['title'],
        movieDate: body['results'][i]['release_date'],
        movieDescription: body['results'][i]['overview'],
        movieImage: body['results'][i]['poster_path'],
        movieScore: body['results'][i]['vote_average'].toDouble(),
        movieCategories: body['results'][i]['genre_ids'],
      ));

      listMovie.add(CustomSeparator(
        screenHeight: _heightScreen,
        screenWidth: _widthScreen,
        backgroundColor: Colors.grey[300]
      ));
    }

    return listMovie;
  }

  Widget constructTopBar(heightScreen, widthScreen) {
    double topBarHeight = heightScreen * topBarHeightPercent;

    return new CustomTopBar(
      context: context,
      heightScreen: heightScreen,
      widthScreen: widthScreen,
      topBarHeight: topBarHeightPercent,
      topBarWidget: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new GestureDetector(
            onTap: () {
              if (listChoice != "trends") {
                buttonCarouselController.previousPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.linear
                );
                setState(() {
                  listChoice = "trends";
                });
              }
            },
            child: new Container(
              alignment: Alignment.center,
              color: Colors.white,
              width: widthScreen / 2,
              padding: EdgeInsets.only(
                left: widthScreen / 8
              ),
              height: topBarHeight,
              child: new CustomText(
                text: "Tendance",
                fontColor: (listChoice == "trends" ? FontColor.blue : FontColor.grey),
                fontSize: FontSize.xl,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          new GestureDetector(
            onTap: () {
              if (listChoice != "discover") {
                buttonCarouselController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.linear
                );
                setState(() {
                  listChoice = "discover";
                });
              }
            },
            child: new Container(
              alignment: Alignment.center,
              color: Colors.white,
              width: widthScreen / 2,
              padding: EdgeInsets.only(
                right: widthScreen / 8
              ),
              height: topBarHeight,
              child: new CustomText(
                text: "Découvrir",
                fontColor: (listChoice == "discover" ? FontColor.blue : FontColor.grey),
                fontSize: FontSize.xl,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      )
    );
  }

  Widget buildSlider(height) {
    return CarouselSlider(
      carouselController: buttonCarouselController,
      options: CarouselOptions(
        height: height,
        viewportFraction: 1,
        enableInfiniteScroll: false,
        autoPlay: false,
        scrollPhysics: ClampingScrollPhysics(),
        onPageChanged: (index, reason) {
          setState(() {
            if (index == 0) {
              listChoice = "trends";
            } else {
              listChoice = "discover";
            }
          });
        },
      ),
      items: <Widget>[
        UdaptableScrollView.CustomScrollView(
          updateMethode: () async {
            await refresh("trends");
          },
          scrollController: _trendsController,
          listWidget: trendsListMovies,
        ),
        UdaptableScrollView.CustomScrollView(
          updateMethode: () async {
            await refresh("discover");
          },
          scrollController: _discoverController,
          listWidget: discoverListMovies,
        ),
      ],
    );
  }

  Future refresh(listToRefresh) async {
    _pageCounter[listToRefresh] = 1;
    if (listToRefresh == "trends") await getTrends(true);
    if (listToRefresh == "discover") await getDiscover(true);
  }

  @override
  void initState() {
    super.initState();

    getTrends(true);
    getDiscover(true);

    _trendsController.addListener(() async {
      if (_trendsController.offset >= _trendsController.position.maxScrollExtent * 0.7) {
        await getTrends(false);
      }
    });

    _discoverController.addListener(() async {
      if (_discoverController.offset >= _discoverController.position.maxScrollExtent * 0.7) {
        await getDiscover(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _widthScreen = MediaQuery.of(context).size.width;
    _heightScreen = MediaQuery.of(context).size.height;

    _sliderHome = buildSlider(_heightScreen);

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        context: context,
        widthScreen: _widthScreen,
        heightScreen: _heightScreen,
      ),
      body: new Stack(
        children: <Widget>[
          constructTopBar(_heightScreen, _widthScreen),
          Padding(
            padding: EdgeInsets.only(top: _heightScreen * topBarHeightPercent),
            child: _sliderHome,
          )
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        context: context,
        widthScreen: _widthScreen,
        heightScreen: _heightScreen,
      ),
    );
  }
}