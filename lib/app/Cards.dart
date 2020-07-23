part of app;

// ignore: must_be_immutable
class Cards extends StatelessWidget {
  final List<Widget> list = List();
  MainState state;

  Cards(MainState state) {
    this.state = state;
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < 5; i++)
      list.add(
        Card(
          color: _colors.set[2],
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10.0)),
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[_lessons.list[i][3]],
                ),
                trailing: _lessons.list[i][0],
                title: _lessons.list[i][1],
                subtitle: _lessons.list[i][2],
                onLongPress: () {
                  showMenu(
                      position:
                          RelativeRect.fromLTRB(120.0, 20.0, 100.0, 100.0),
                      context: context,
                      items: <PopupMenuEntry>[
                        PopupMenuItem(
                          value: 1,
                          key: new Key(""),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  var deleteId = await _db.rawQuery(
                                      "SELECT objectId FROM lessons "
                                      "WHERE lessons.num = $i "
                                      "AND lessons.day = ${_cur.weekday} "
                                      "AND lessons.week = ${weekNumber(_cur) % 2}");
                                  ParseObject('schedule')
                                      .delete(id: deleteId.first["objectId"]);
                                  await _db.rawDelete("DELETE FROM lessons "
                                      "WHERE lessons.num = $i "
                                      "AND lessons.day = ${_cur.weekday} "
                                      "AND lessons.week = ${weekNumber(_cur) % 2}");
                                  state.move();
                                },
                              ),
                            ],
                          ),
                        )
                      ]);
                },
              ),
              Padding(padding: EdgeInsets.only(bottom: 10.0)),
            ],
          ),
        ),
      );
    return ListView(padding: const EdgeInsets.all(8.0), children: list);
  }
}
