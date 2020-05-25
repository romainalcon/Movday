import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

String formatDateWithLocale(String dateToConvert) {
  initializeDateFormatting();
  var standardDateFormat = new DateFormat("yyyy-MM-dd");
  DateTime tmp = standardDateFormat.parse(dateToConvert);
  DateFormat finalFormat = new DateFormat.yMMMMd("fr_FR");

  return finalFormat.format(tmp);
}

void showSnackbar(GlobalKey<ScaffoldState> scaffoldState, String value) {
  final snackBar = SnackBar(content: Text(value));
  scaffoldState.currentState.hideCurrentSnackBar();
  scaffoldState.currentState.showSnackBar(snackBar);
}