package dots;

using thx.Strings;

class Attributes {
  public static function asAttribute(map : Map<String, Bool>) : String {
    var collect = [];
    for(key in map.keys())
      if(map.get(key))
        collect.push(key);
    return collect.join(" ");
  }

  public static function asStyle(map : Map<String, String>) : String {
    var collect = [];
    for(key in map.keys()) {
      var value = map.get(key);
      if(value.isEmpty())
        continue;
      collect.push('$key: $value;');
    }
    return collect.join(" ");
  }
}
