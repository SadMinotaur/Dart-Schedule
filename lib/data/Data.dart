part of app;

class Data {
  final _days = [
    "Понедельник",
    "Вторник",
    "Среда",
    "Четверг",
    "Пятница",
    "Суббота",
    "Воскресенье"
  ];

  var _date = "";
  var _week = "";
  var _carriage = 0;

  List _list = [
    [Text(""), Text(""), Text(""), Text("")],
    [Text(""), Text(""), Text(""), Text("")],
    [Text(""), Text(""), Text(""), Text("")],
    [Text(""), Text(""), Text(""), Text("")],
    [Text(""), Text(""), Text(""), Text("")]
  ];

  void cleanOne(int i) {
    for (var b = 0; b < _list[i].length; b++) _list[i][b] = Text("");
  }

  void clean() {
    for (var i = 0; i < _list.length; i++) {
      for (var b = 0; b < _list[0].length; b++) _list[i][b] = Text("");
    }
  }
}
