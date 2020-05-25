import 'package:Movday/icons/movday_icons.dart';
import 'package:Movday/librairies/Categories.dart';
import 'package:Movday/librairies/Common.dart';
import 'package:Movday/librairies/Request.dart';
import 'package:Movday/librairies/Search.dart';
import 'package:Movday/widgets/CustomAppBar.dart';
import 'package:Movday/widgets/CustomBottomBar.dart';
import 'package:Movday/widgets/CustomItemCard.dart';
import 'package:Movday/widgets/CustomSeparator.dart';
import 'package:Movday/widgets/CustomText.dart';
import 'package:Movday/widgets/CustomTopBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:load/load.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _screenWidth;
  double _screenHeight;

  var categories = Categories();
  List categoriesList = [];
  List<bool> checkedCategoriesList = [];

  List<Widget> listLastSearchWidget = [];
  List<Widget> searchListMovies = [];

  final searchFieldController = TextEditingController();
  ScrollController _searchController = new ScrollController();

  Search sharedSearch = new Search();

  final double topBarHeightPercent = 0.06;

  bool isLoadingSearch = false;
  bool hasSearchResult = false;

  int _pageCounter = 1;

  String _searchTerms = "";
  bool _isCategorySearch = false;
  int _categoryIndex;

  Future<void> getLastSearch() async {
    List<String> listLastSearchString = sharedSearch.getLastSearch();
    if (!mounted) return false;
    setState(() {
      listLastSearchWidget = generateLastSearchList(listLastSearchString);
    });
  }

  Future<void> searchMovies(bool newList) async {
    if (!isLoadingSearch) {
      isLoadingSearch = true;

      if (newList) {
        showLoadingDialog();
        _pageCounter = 1;
      }

      var response;

      if (_isCategorySearch) {
        response = await fetchPost(RequestType.get, "/discover/movie", {
          "page": _pageCounter.toString(),
          "sort_by": "popularity.desc",
          "with_genres": categoriesList[_categoryIndex]['id'].toString()
        });
      } else {
        response = await fetchPost(RequestType.get, "/search/movie", {
          "page": _pageCounter.toString(),
          "query": Uri.encodeFull(_searchTerms)
        });
      }

      if (response.status == 200) {
        var listMovies = generateListMoviesFromBody(response.body);

        if (listMovies.length > 0) {
          _pageCounter++;
          
          if (!mounted) return false;

          setState(() {
            if (newList) {
              searchListMovies = listMovies;
            } else {
              searchListMovies = new List.from(searchListMovies)..addAll(listMovies);
            }

            hasSearchResult = true;
          });
        } else {
          //showSnackbar(_scaffoldKey, "Aucun résulat ne correspond à votre recherche");
          hasSearchResult = false;
        }
      }
      isLoadingSearch = false;

      if (newList) hideLoadingDialog();
    }
  }

  List<Widget> generateListMoviesFromBody(body) {
    List<Widget> listMovies = [];

    for (var i = 0; i < body['results'].length; i++) {
      if (body['results'][i]['id'] == null) continue;
      if (body['results'][i]['title'] == null ||
          body['results'][i]['title'].length == 0) continue;
      if (body['results'][i]['release_date'] == null ||
          body['results'][i]['release_date'].length == 0) continue;
      if (body['results'][i]['overview'] == null ||
          body['results'][i]['overview'].length == 0) continue;
      if (body['results'][i]['poster_path'] == null ||
          body['results'][i]['poster_path'].length == 0) continue;
      if (body['results'][i]['vote_average'] == null) continue;
      if (body['results'][i]['genre_ids'] == null) continue;

      listMovies.add(CustomItemCard(
        scaffoldKey: _scaffoldKey,
        heightScreen: _screenHeight,
        widthScreen: _screenWidth,
        movieId: body['results'][i]['id'],
        movieTitle: body['results'][i]['title'],
        movieDate: body['results'][i]['release_date'],
        movieDescription: body['results'][i]['overview'],
        movieImage: body['results'][i]['poster_path'],
        movieScore: body['results'][i]['vote_average'].toDouble(),
        movieCategories: body['results'][i]['genre_ids'],
      ));
      listMovies.add(CustomSeparator(screenHeight: _screenHeight, screenWidth: _screenWidth, backgroundColor: Colors.grey[300]));
    }

    return listMovies;
  }

  List<Widget> generateLastSearchList(listSearch) {
    double _screenWidth = MediaQuery.of(context).size.width;

    List<Widget> widgetList = [];

    for (var i = 0; i < listSearch.length; i++) {
      widgetList.add(
        GestureDetector(
          onTap: () {
            _searchTerms = listSearch[i];
            _isCategorySearch = false;
            searchFieldController.value = new TextEditingController.fromValue(
              new TextEditingValue(
                text: _searchTerms
              )
            ).value;
            searchMovies(true);
          },
          child: Container(
            alignment: Alignment.center,
            color: Colors.white,
            padding: EdgeInsets.only(
              top: _screenWidth * 0.02,
              bottom: _screenWidth * 0.02,
              left: _screenWidth * 0.06,
              right: _screenWidth * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomText(
                  text: listSearch[i],
                  fontColor: FontColor.grey,
                  fontSize: FontSize.lg,
                ),
                IconButton(
                  icon: Icon(Movday.plus),
                  iconSize: CustomText.textSize(FontSize.xl),
                  color: CustomText.textColor(FontColor.grey),
                  onPressed: () async {
                    await sharedSearch.removeSearch(i);
                    await getLastSearch();
                  },
                )
              ],
            ),
          ),
        )
      );

      widgetList.add(CustomSeparator(
        screenWidth: _screenWidth,
        screenHeight: _screenHeight,
      ));
    }

    return widgetList;
  }

  Widget constructTopBar(heightScreen, widthScreen) {
    return CustomTopBar(
      context: context,
      widthScreen: widthScreen,
      heightScreen: heightScreen,
      topBarHeight: topBarHeightPercent,
      topBarWidget: CustomText(
        text: "Rechercher",
        fontColor: FontColor.blue,
        fontSize: FontSize.lg,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildSearchBarContainer(heightScreen, widthScreen) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: widthScreen * 0.03,
            vertical: widthScreen * 0.02,
          ),
          width: widthScreen,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  right: widthScreen * 0.02
                ),
                child: Icon(
                  Movday.search,
                  size: widthScreen * 0.06,
                  color: CustomText.textColor(FontColor.dark),
                ),
              ),
              Flexible(
                child: TextField(
                  controller: searchFieldController,
                  style: TextStyle(
                    fontSize: CustomText.textSize(FontSize.lg)
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Recherche..."
                  ),
                  onTap: () {
                    if (_isCategorySearch) {
                      _isCategorySearch = false;
                      searchFieldController.value = new TextEditingController.fromValue(
                        new TextEditingValue(text: "")
                      ).value;
                    }
                  },
                ),
              ),
              GestureDetector(
                child: CustomText(
                  text: "Par genre",
                  fontColor: FontColor.blue,
                  fontSize: FontSize.md,
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {
                  showPicker();
                },
              )
            ],
          ),
        ),
        GestureDetector(
          child: Container(
            width: widthScreen,
            padding: EdgeInsets.symmetric(
              horizontal: widthScreen * 0.03,
              vertical: widthScreen * 0.03
            ),
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
            child: CustomText(
              text: "Rechercher",
              fontColor: FontColor.white,
              fontSize: FontSize.lg,
              fontWeight: FontWeight.bold
            )
          ),
          onTap: () async {
            _searchTerms = searchFieldController.text;

            if (!_isCategorySearch && _searchTerms.length > 0) {
              FocusScope.of(context).requestFocus(FocusNode());
              _isCategorySearch = false;
              await searchMovies(true);
              await sharedSearch.addSearch(_searchTerms);
              getLastSearch();
            }
          },
        ),
        CustomSeparator(
          screenHeight: _screenHeight,
          screenWidth: _screenWidth,
          backgroundColor: Colors.grey[300],
        )
      ],
    );
  }

  List<String> buildCategoriesList() {
    List<String> checkboxList = [];
    for (var i = 0; i < categoriesList.length; i++) {
      checkboxList.add(categoriesList[i]["name"]);
    }
    return checkboxList;
  }

  showPicker() {
    new Picker(
      adapter: PickerDataAdapter<String>(
        pickerdata: buildCategoriesList()
      ),
      hideHeader: true,
      itemExtent: 40,
      height: 200,
      cancelText: "Annuler",
      confirmText: "Confirmer",
      onConfirm: (picker, selecteds) {
        String categoryNameSelect = picker.getSelectedValues()[0].toUpperCase();
        int categoryIdSelect = selecteds[0];

        _isCategorySearch = true;
        _categoryIndex = categoryIdSelect;

        searchFieldController.value = new TextEditingController.fromValue(
          new TextEditingValue(
            text: categoryNameSelect
          )
        ).value;

        searchMovies(true);
      },
    ).showDialog(context);
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

    _searchController.addListener(() async {
      if (_searchController.offset >= _searchController.position.maxScrollExtent * 0.7) {
        await searchMovies(false);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await sharedSearch.initLastSearch();
      await categories.initCategories(context);
      categoriesList = categories.getAllCategories();

      await getLastSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    List<Widget> listBodyWidget;

    if (hasSearchResult) {
      listBodyWidget = new List.from([
        buildSearchBarContainer(_screenHeight, _screenWidth),
        CustomSeparator(screenHeight: _screenHeight, screenWidth: _screenWidth, backgroundColor: Colors.grey[300],)
      ])..addAll(searchListMovies);
    } else {
      listBodyWidget = new List.from([
        buildSearchBarContainer(_screenHeight, _screenWidth),
        CustomSeparator(screenHeight: _screenHeight, screenWidth: _screenWidth, backgroundColor: Colors.grey[300],)
      ])..addAll(listLastSearchWidget);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        context: context,
        widthScreen: _screenWidth,
        heightScreen: _screenHeight,
      ),
      body: new Stack(
        children: <Widget>[
          constructTopBar(_screenHeight, _screenWidth),
          Container(
            width: _screenWidth,
            padding: EdgeInsets.only(top: _screenHeight * topBarHeightPercent),
            child: SingleChildScrollView(
              controller: _searchController,
              physics: new ClampingScrollPhysics(),
              child: Column(
                children: listBodyWidget,
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        context: context,
        widthScreen: _screenWidth,
        heightScreen: _screenHeight,
      ),
    );
  }
}