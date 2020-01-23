library app;

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schedule/ScaleRoute.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'Cards.dart';
part 'Data.dart';
part 'MainState.dart';
part 'AddLe.dart';
part 'Settings.dart';
part 'Colors.dart';

var _lessons = Data();
var _colors = ColorsData();

DateTime _cur;
Database _db;
bool _layout;
bool _theme = true;

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

void saveLayout(bool get) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("layout", get);
}

void saveTheme(bool get) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("theme", get);
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
  MainState createState() => MainState();
}
