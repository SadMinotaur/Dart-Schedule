part of app;

class GroupParse extends ParseObject implements ParseCloneable {
  GroupParse() : super('group');

  GroupParse.clone() : this();

  static const String university = 'university';

  @override
  clone(Map map) => GroupParse.clone()..fromJson(map);
}
