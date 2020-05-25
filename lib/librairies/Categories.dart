import 'dart:convert';
import 'package:flutter/cupertino.dart';

class Categories {
  static Categories _instance;
  BuildContext _currentContext;

  List<dynamic> categoriesData;

  static Categories get instance {
    if (_instance == null) _instance = new Categories();
    return _instance; 
  }

  Future initCategories(context) async {
    _currentContext = context;
    String data = await DefaultAssetBundle.of(context).loadString("assets/categories/fr.json");
    this.categoriesData = json.decode(data)["genres"];
  }

  String getNameCategorie(int id) {
    var name = "";
    for (var i = 0; i < this.categoriesData.length; i++) {
      if (this.categoriesData[i]['id'] == id) {
        name = this.categoriesData[i]['name'];
      }
    }
    return name;
  }

  String getNameArrayCategorie(List movieCategorie) {
    List<String> arrayResult = [];
    int length = (movieCategorie.length > 2 ? 2 : movieCategorie.length);
    for (var i = 0; i < length; i++) {
      arrayResult.add(getNameCategorie(movieCategorie[i]));
    }
    return arrayResult.join(", ");
  }

  List<dynamic> getAllCategories() {
    return this.categoriesData;
  }

}