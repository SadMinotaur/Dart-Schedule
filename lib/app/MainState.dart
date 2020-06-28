part of app;

//Keys from back4app
const String PARSE_APP_ID = '';
const String PARSE_APP_URL = '';
const String MASTER_KEY = '';

class MainState extends State<MyApp> {
  void initParse() async {
    await Parse().initialize(PARSE_APP_ID, PARSE_APP_URL,
        masterKey: MASTER_KEY, autoSendSessionId: true);
  }

  void curDate() async {
    readTheme().then((value) {
      if (_theme != value) {
        _theme = value;
        _colors._switch();
      }
    });
    if (_db == null) await load();
    _cur = DateTime.now().add(Duration(days: _lessons._carriage));
    int week;
    var _week = "";
    var date = "${_lessons._days[_cur.weekday - 1]} ${_cur.day}.${_cur.month} ";
    if (weekNumber(_cur) % 2 == 0) {
      _week = "Четная неделя";
      week = 0;
    } else {
      week = 1;
      _week = "Нечетная неделя";
    }
    setState(() {
      _lessons._week = _week;
      _lessons._date = date;
    });
    var get = _db.rawQuery(
        "SELECT lessons.num,lessons.name,lessons.teacher,lessons.place,lessons.type"
        " FROM lessons WHERE lessons.week = $week "
        "AND lessons.day = ${_cur.weekday}");
    try {
      {
        get.then((value) {
          for (var s = 0; s < value.length; s++) {
            var r = value[s].values.toList(growable: false);
            setState(() {
              _lessons._list[int.parse(r[0].toString())][1] =
                  Text(r[1].toString(), style: _colors.currentStyle);
              _lessons._list[int.parse(r[0].toString())][2] =
                  Text(r[2].toString(), style: _colors.currentStyle);
              _lessons._list[int.parse(r[0].toString())][0] =
                  Text(r[3].toString(), style: _colors.currentStyle);
              _lessons._list[int.parse(r[0].toString())][3] =
                  Text(r[4].toString(), style: _colors.currentStyle);
            });
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void sync(GlobalKey<ScaffoldState> state) async {
    var apiResponse = await ParseObject('schedule').getAll();
    if (apiResponse.success && apiResponse.result != null) {
      _db.rawDelete("DELETE FROM lessons");
      Map<String, dynamic> map;
      for (var lesson in apiResponse.result) {
        map = jsonDecode(lesson.toString());
        _db.rawInsert(
            "INSERT INTO lessons (num,day,week,name,teacher,place,type)"
            " VALUES (${map["num"]},${map["day"]},${map["weekEven"] ? 0 : 1},"
            "'${map["name"]}','${map["teacher"]}','${map["place"]}','${map["type"]}')");
      }
      move();
    } else {
      final snackBar = SnackBar(content: Text('Ошибка синхронизации'));
      state.currentState.showSnackBar(snackBar);
    }
  }

  void move() {
    _lessons.clean();
    curDate();
  }

  dynamic ret(r, BuildContext context, bool boo) {
    if (_layout == null)
      readLayout().then((a) {
        _layout = a;
        if (_layout == boo) return r;
        return null;
      });
    if (_layout == boo) return r;
    return null;
  }

  @override
  void initState() {
    initParse();
    curDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.set[1],
      key: _key,
      appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.cloud_download),
                onPressed: () {
                  sync(_key);
                }),
            ret(
                    IconButton(
                        onPressed: () async {
                          Navigator.push(
                              context, ScaleRoute(page: AddLe(this)));
                        },
                        icon: Icon(Icons.add_circle)),
                    context,
                    false) ??
                Text(""),
            Padding(padding: EdgeInsets.all(8.0)),
          ],
          backgroundColor: _colors.set[0],
          leading: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                Navigator.push(context, ScaleRoute(page: Settings()));
              }),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_lessons._date),
              Text(_lessons._week),
            ],
          )),
      body: Cards(this),
      floatingActionButton: ret(
          FloatingActionButton(
            backgroundColor: Colors.cyan,
            child: Icon(Icons.add),
            onPressed: () async {
              Navigator.push(context, ScaleRoute(page: AddLe(this)));
            },
          ),
          context,
          true),
      bottomNavigationBar: BottomAppBar(
        color: _colors.set[0],
        child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    _lessons._carriage -= 7;
                    move();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    _lessons._carriage -= 1;
                    move();
                  },
                ),
                ret(
                        IconButton(
                          icon: Icon(Icons.home),
                          onPressed: () {
                            _lessons._carriage = 0;
                            move();
                          },
                        ),
                        context,
                        false) ??
                    Text(""),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    _lessons._carriage += 1;
                    move();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    _lessons._carriage += 7;
                    move();
                  },
                )
              ],
            ),
            height: 60.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
