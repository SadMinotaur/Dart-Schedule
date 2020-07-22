part of app;

Future<bool> readLayout() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool("layout") ?? false;
}

Future<bool> readTheme() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool("theme") ?? true;
}

Future<String> readGroup() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("group");
}

Future<String> readUniversity() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("university");
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

void saveUniversity(String set) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("university", set);
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

Future<ParseResponse> getUniversity() async {
  return await ParseObject('university').getAll();
}

Future<ParseResponse> getSchedule() async {
  var query = QueryBuilder<ScheduleParse>(ScheduleParse())
    ..whereContains(ScheduleParse.group, _group, caseSensitive: true)
    ..whereContains(ScheduleParse.university, _university, caseSensitive: true);
  return await query.query();
}

dynamic ret(r, BuildContext context, bool bool) {
  if (_layout == null)
    readLayout().then((layout) {
      _layout = layout;
      if (_layout == bool) return r;
      return null;
    });
  if (_layout == bool) return r;
  return null;
}

void initParse() async {
  await Parse().initialize(PARSE_APP_ID, PARSE_APP_URL,
      masterKey: MASTER_KEY, autoSendSessionId: true, debug: true);
}
