package dots;

import js.html.Element;
import js.html.NodeList;

class Query {
  static var doc : Element = untyped __js__('document');

  public static function find<T : Element>(selector : String, ?ctx : Element) : T
    return cast (ctx != null ? ctx : doc).querySelector(selector);

  public static function selectNodes(selector : String, ?ctx : Element) : NodeList
    return (ctx != null ? ctx : doc).querySelectorAll(selector);

  public inline static function select<T : Element>(selector : String, ?ctx : Element) : Array<T>
    return cast Html.nodeListToArray(selectNodes(selector, ctx));

  public static function getElementIndex(el : Element) {
    var index = 0;
    while(null != (el = el.previousElementSibling))
      index++;
    return index;
  }

  public static function childrenOf<T : Element>(children : Array<Element>, parent : Element) : Array<T>
    return cast children.filter(function(child) return child.parentElement == parent);
}
