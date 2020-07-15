library app;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'app/ScaleRoute.dart';

part 'app/Cards.dart';

part 'data/Data.dart';

part 'app/MainState.dart';

part 'app/AddLe.dart';

part 'app/Settings.dart';

part 'data/Colors.dart';

part 'data/Schedule.dart';

//Keys from back4app
const String PARSE_APP_ID = '';
const String PARSE_APP_URL = '';
const String MASTER_KEY = '';
Data _lessons = Data();
ColorsData _colors = ColorsData();
DateTime _cur;
Database _db;
bool _layout;
String _group;
bool _theme = true;
GlobalKey<ScaffoldState> _key = new GlobalKey();

Future<bool> readLayout() async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getBool("layout") ?? false;
  return value;
}

Future<bool> readTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getBool("theme") ?? true;
  return value;
}

Future<String> readGroup() async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getString("group");
  return value;
}

void saveLayout(bool set) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("layout", set);
}

void saveTheme(bool set) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("theme", set);
}

void saveGroup(String set) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("group", set);
}

int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}

Future load() async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "data.db");
  var exists = await databaseExists(path);
  if (!exists)
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}
  ByteData data = await rootBundle.load(join("assets", "data.db"));
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await File(path).writeAsBytes(bytes, flush: true);
  _db = await openDatabase(path);
}

class MyApp extends StatefulWidget {
  @override
  MainState createState() {
    return MainState();
  }
}

void main() {
  runApp(MaterialApp(home: MyApp()));
}