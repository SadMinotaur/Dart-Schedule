part of app;

// ignore: must_be_immutable
class Settings extends StatefulWidget {
  MainState state;

  Settings(this.state);

  @override
  SettingsC createState() => SettingsC(state);
}

class SettingsC extends State<Settings> {
  MainState state;

  SettingsC(this.state);

  void changeLayout(bool value) {
    setState(() {
      saveLayout(value);
      _layout = value;
    });
  }

  void changeTheme(bool value) {
    setState(() {
      _theme = value;
      _colors.switchTheme();
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
            Container(
                padding: EdgeInsets.only(left: 17),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Сменить группу и ВУЗ",
                      style: _colors.currentStyle,
                    ),
                    Padding(padding: EdgeInsets.only(left: 22)),
                    IconButton(
                        alignment: Alignment.centerRight,
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _university = null;
                          saveUniversity(null);
                          _group = null;
                          saveGroup(null);
                          state.sync();
                        }),
                  ],
                ))
          ]),
        ));
  }
}
