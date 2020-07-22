part of app;

class Data {
  final days = [
    "Понедельник",
    "Вторник",
    "Среда",
    "Четверг",
    "Пятница",
    "Суббота",
    "Воскресенье"
  ];

  var date = "";
  var week = "";
  var carriage = 0;

  List list = [
    [Text(""), Text(""), Text(""), Text("")],
    [Text(""), Text(""), Text(""), Text("")],
    [Text(""), Text(""), Text(""), Text("")],
    [Text(""), Text(""), Text(""), Text("")],
    [Text(""), Text(""), Text(""), Text("")]
  ];

  void cleanOne(int i) {
    for (var b = 0; b < list[i].length; b++) list[i][b] = Text("");
  }

  void clean() {
    for (var i = 0; i < list.length; i++) {
      for (var b = 0; b < list[0].length; b++) list[i][b] = Text("");
    }
  }
}
