package dots;

import js.html.Element;
import js.html.NodeList;

class Query {
  static var doc : Element = untyped __js__('document');

  public static function first(selector : String, ?ctx : js.html.Element) : Element
    return (ctx != null ? ctx : doc).querySelector(selector);

  public static function list(selector : String, ?ctx : js.html.Element) : NodeList
    return (ctx != null ? ctx : doc).querySelectorAll(selector);

  public inline static function all(selector : String, ?ctx : js.html.Element) : Array<Element>
    return Html.nodeListToArray(list(selector, ctx));

  public static function getElementIndex(el : Element) {
    var index = 0;
    while(null != (el = el.previousElementSibling))
      index++;
    return index;
  }

  public static function childrenOf(children : Array<Element>, parent : Element) : Array<Element>
    return children.filter(function(child) return child.parentElement == parent);
}