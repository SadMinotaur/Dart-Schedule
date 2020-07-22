part of app;

class MainState extends State<MyApp> {
  void curDate() async {
    readTheme().then((value) {
      _theme = value;
      _colors.switchTheme();
    });
    if (_db == null) await load();
    _cur = DateTime.now().add(Duration(days: _lessons.carriage));
    int week;
    var thisWeek = "";
    var date = "${_lessons.days[_cur.weekday - 1]} ${_cur.day}.${_cur.month} ";
    if (weekNumber(_cur) % 2 == 0) {
      thisWeek = "Четная неделя";
      week = 0;
    } else {
      week = 1;
      thisWeek = "Нечетная неделя";
    }
    setState(() {
      _lessons.week = thisWeek;
      _lessons.date = date;
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
              _lessons.list[int.parse(r[0].toString())][1] =
                  Text(r[1].toString(), style: _colors.currentStyle);
              _lessons.list[int.parse(r[0].toString())][2] =
                  Text(r[2].toString(), style: _colors.currentStyle);
              _lessons.list[int.parse(r[0].toString())][0] =
                  Text(r[3].toString(), style: _colors.currentStyle);
              _lessons.list[int.parse(r[0].toString())][3] =
                  Text(r[4].toString(), style: _colors.currentStyle);
            });
          }
        });
      }
    } catch (e) {}
//    readGroup().then((value) {
//      _group = value;
//    });
//    readUniversity().then((value) {
//      _university = value;
//    });
  }

  void sync(GlobalKey<ScaffoldState> state) async {
    if (_group == null || _university == null) {
      await Navigator.push(
          state.currentContext, ScaleRoute(page: ChooseState(await getUniversity())));
    }
    if (_group == null || _university == null) {
      return;
    }
    var apiResponse = await getSchedule();
    if (apiResponse.success && apiResponse.result != null) {
      _db.rawDelete("DELETE FROM lessons");
      Map<String, dynamic> map;
      for (var lesson in apiResponse.result) {
        map = jsonDecode(lesson.toString());
        _db.rawInsert(
            "INSERT INTO lessons (num,day,week,name,teacher,place,type, objectId)"
            " VALUES (${map["num"]},${map["day"]},${map["weekEven"] ? 0 : 1},"
            "'${map["name"]}','${map["teacher"]}','${map["place"]}','${map["type"]}','${map["objectId"]}')");
      }
      move();
    } else {
      final snackBar = SnackBar(content: Text('Ошибка синхронизации'));
      state.currentState.showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    initParse();
    curDate();
    super.initState();
  }

  void move() {
    _lessons.clean();
    curDate();
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
                              context, ScaleRoute(page: AddLesson()));
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
              Text(_lessons.date),
              Text(_lessons.week),
            ],
          )),
      body: Cards(this),
      floatingActionButton: ret(
          FloatingActionButton(
            backgroundColor: Colors.cyan,
            child: Icon(Icons.add),
            onPressed: () async {
              Navigator.push(context, ScaleRoute(page: AddLesson()));
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
                    _lessons.carriage -= 7;
                    move();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    _lessons.carriage -= 1;
                    move();
                  },
                ),
                ret(
                        IconButton(
                          icon: Icon(Icons.home),
                          onPressed: () {
                            _lessons.carriage = 0;
                            move();
                          },
                        ),
                        context,
                        false) ??
                    Text(""),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    _lessons.carriage += 1;
                    move();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    _lessons.carriage += 7;
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
