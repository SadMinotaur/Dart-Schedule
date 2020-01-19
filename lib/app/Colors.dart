part of app;

class ColorsData {
  static final darkFirstColor = Colors.deepPurple;
  static final darkSecondColor = Color(0xff3b394e);
  static final darkThirdColor = Color(0xff6865a5);

  static final lightFirstColor = Color(0xff9068ff);
  static final lightSecondColor = Color(0xffffffff);
  static final lightThirdColor = Colors.white70;

  var set = [darkFirstColor, darkSecondColor, darkThirdColor];
  var currentStyle = darkStyleTex;

  static final lightStyleTex = TextStyle(color: Colors.black, fontSize: 20);
  static final darkStyleTex = TextStyle(color: Colors.white, fontSize: 20);

  void _switch() {
    if (_theme) {
      currentStyle = darkStyleTex;
      set = [darkFirstColor, darkSecondColor, darkThirdColor];
    } else {
      currentStyle = lightStyleTex;
      set = [lightFirstColor, lightSecondColor, lightThirdColor];
    }
  }
}
