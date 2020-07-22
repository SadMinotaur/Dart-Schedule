part of app;

class AddLesson extends StatelessWidget {

  final List<Widget> _list = List();
  final values = ["", "", "", "", ""];
  final List name = ["Номер", "Занятие", "Преподаватель", "Аудитория", "Тип"];

  @override
  Widget build(BuildContext context) {
    _list.add(
        Center(child: Text("Добавление пары", style: _colors.currentStyle)));
    _list.add(
      Padding(padding: const EdgeInsets.all(20.0)),
    );
    _list.add(
      Card(
          color: _colors.set[2],
          child: Column(children: <Widget>[
            Text(
              name[0],
              style: _colors.currentStyle,
            ),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 1,
              onChanged: (text) {
                values[0] = text;
              },
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.sentences,
            )
          ])),
    );
    for (var i = 1; i < 5; i++) {
      _list.add(Card(
          color: _colors.set[2],
          child: Column(children: <Widget>[
            Text(
              name[i],
              style: _colors.currentStyle,
            ),
            TextField(
              onChanged: (text) {
                values[i] = text;
              },
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.sentences,
            )
          ])));
    }
    return Scaffold(
      backgroundColor: _colors.set[1],
      appBar: AppBar(
        backgroundColor: _colors.set[0],
      ),
      key: key,
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: _list,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
        onPressed: () {
          if (int.parse(values[0]) < 6 && int.parse(values[0]) > 0)
            _db.rawInsert(
                "INSERT INTO lessons (num,day,week,name,teacher,place,type)"
                " VALUES (${int.parse(values[0]) - 1},${_cur.weekday},${weekNumber(_cur) % 2},"
                "'${values[1]}','${values[2]}','${values[3]}','${values[4]}')");
          Navigator.push(context, ScaleRoute(page: MyApp()));
        },
      ),
    );
  }
}
