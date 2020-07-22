part of app;

class ScheduleParse extends ParseObject implements ParseCloneable {
  ScheduleParse() : super('schedule');

  ScheduleParse.clone() : this();

  static const String table = 'schedule';
  static const String group = 'group';
  static const String university = 'university';

  @override
  clone(Map map) => ScheduleParse.clone()..fromJson(map);

  String get name => get<String>(group);

  set name(String name) => set<String>(group, name);
}
