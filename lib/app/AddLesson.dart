part of app;

// ignore: must_be_immutable
class AddLesson extends StatelessWidget {
  final List<Widget> list = List();
  final values = ["", "", "", "", ""];
  final List name = ["Номер", "Занятие", "Преподаватель", "Аудитория", "Тип"];
  MainState state;

  AddLesson(this.state);

  @override
  Widget build(BuildContext context) {
    list.add(
        Center(child: Text("Добавление пары", style: _colors.currentStyle)));
    list.add(
      Padding(padding: const EdgeInsets.all(20.0)),
    );
    list.add(
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
      list.add(Card(
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
        children: list,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: _colors.set[0],
        onPressed: () async {
          try {
            if (int.parse(values[0]) < 6 && int.parse(values[0]) > 0) {
              var addObj = ParseObject('schedule')
                ..set('num', int.parse(values[0]) - 1)
                ..set('day', _cur.weekday)
                ..set('weekEven', weekNumber(_cur) % 2 == 0 ? true : false)
                ..set('name', values[1])
                ..set('teacher', values[2])
                ..set('place', values[3])
                ..set('type', values[4])
                ..set('group', _group)
                ..set('university', _university);
              await addObj.save();
              state.sync(_key);
              Navigator.pop(context, ScaleRoute());
            }
          } catch (_) {}
        },
      ),
    );
  }
}