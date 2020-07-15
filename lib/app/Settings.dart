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
            ])));
  }
}
