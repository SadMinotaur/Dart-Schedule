part of app;

class Settings extends StatefulWidget {
  @override
  SettingsC createState() => SettingsC();
}

class SettingsC extends State<Settings> {
  void changeLayout(bool value) {
    setState(() {
      saveLayout(value);
      _layout = value;
    });
  }

  void changeTheme(bool value) {
    setState(() {
      _theme = value;
      _colors._switch();
      saveTheme(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: _colors.set[0],
        ),
        backgroundColor: _colors.set[1],
        key: GlobalKey<ScaffoldState>(),
        body: Container(
            padding: EdgeInsets.all(32.0),
            child: Column(children: <Widget>[
              SwitchListTile(
                  value: _layout,
                  onChanged: changeLayout,
                  title: Text('Альтернативная раскладка',
                      style: _colors.currentStyle)),
              SwitchListTile(
                  value: _theme,
                  onChanged: changeTheme,
                  title: Text('Темная тема', style: _colors.currentStyle)),
              Text('Расписание', style: _colors.currentStyle),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('1 пара: 8:00 - 9:35', style: _colors.currentStyle),
                  Text('2 пара: 9:45 - 11:20', style: _colors.currentStyle),
                  Text('3 пара: 11:30 - 13:05', style: _colors.currentStyle),
                  Text('4 пара: 13:55 - 15:30', style: _colors.currentStyle),
                  Text('5 пара: 15:40 - 17:15', style: _colors.currentStyle)
                ],
              )
            ])));
  }
}
