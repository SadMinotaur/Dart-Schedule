part of app;

class ChooseState extends StatefulWidget {
  final ParseResponse parseResponse;

  ChooseState(this.parseResponse);

  @override
  Choose createState() => Choose(parseResponse);
}

class Choose extends State<ChooseState> {
  final ParseResponse universities;
  final Map<String, bool> widgets = new HashMap();
  Color colorTapped = _colors.set[2];

  Choose(this.universities);

  @override
  void initState() {
    if (universities.success) {
      Map<String, dynamic> map;
      for (var group in universities.result) {
        map = jsonDecode(group.toString());
        widgets[map["name"]] = true;
      }
      super.initState();
    }
  }

  Widget build(BuildContext context) {
    List<String> keys = widgets.keys.toList(growable: false);
    return Scaffold(
        backgroundColor: _colors.set[1],
        appBar: AppBar(
          backgroundColor: _colors.set[0],
          title: new Text("Выбор группы и ВУЗа"),
        ),
        body: ListView.builder(
            itemCount: widgets.length,
            itemBuilder: (context, index) {
              if (widgets[keys[index]]) {
                return Card(
                    color: colorTapped,
                    child: Column(children: <Widget>[
                      ListTile(
                          title: new Text(
                            keys[index],
                            style: _colors.currentStyle,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () async {
                            _university = keys[index];
                            saveUniversity(_university);
                            setState(() {
                              colorTapped = Colors.deepOrangeAccent;
                              widgets.removeWhere(
                                  (key, value) => key != keys[index]);
                            });
                            var query = QueryBuilder<GroupParse>(GroupParse())
                              ..whereContains(
                                  ScheduleParse.university, _university,
                                  caseSensitive: true);
                            var groups = await query.query();
                            if (groups.success) {
                              Map<String, dynamic> map;
                              for (var group in groups.result) {
                                map = jsonDecode(group.toString());
                                setState(() {
                                  widgets[map["name"]] = false;
                                });
                              }
                            }
                          })
                    ]));
              } else {
                var name = widgets.keys.toList()[index];
                return Card(
                    color: _colors.set[2],
                    child: Column(children: <Widget>[
                      ListTile(
                          title: new Text(
                            name,
                            style: _colors.currentStyle,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            _group = name;
                            saveGroup(name);
                            Navigator.pop(context, ScaleRoute(page: MyApp()));
                          })
                    ]));
              }
            }));
  }
}
