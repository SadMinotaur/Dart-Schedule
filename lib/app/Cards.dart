part of app;

class Cards extends StatelessWidget {
  final List<Widget> _list = List();
  MainState stateM;

  Cards(MainState state) {
    stateM = state;
  }

  final _key = Key("");

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < 5; i++)
      _list.add(
        Card(
          color: _colors.set[2],
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10.0)),
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _lessons._list[i][3]
                  ],
                ),
                trailing: _lessons._list[i][0],
                title: _lessons._list[i][1],
                subtitle: _lessons._list[i][2],
                onLongPress: () {
                  showMenu(
                      position:
                      RelativeRect.fromLTRB(120.0, 20.0, 100.0, 100.0),
                      context: context,
                      items: <PopupMenuEntry>[
                        PopupMenuItem(
                          value: 1,
                          key: _key,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _db.rawDelete("DELETE FROM lessons "
                                      "WHERE lessons.num = $i "
                                      "AND lessons.day = ${_cur.weekday} "
                                      "AND lessons.week = ${weekNumber(_cur) % 2}");
                                  stateM.move();
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
    return ListView(padding: const EdgeInsets.all(8.0), children: _list);
  }
}
