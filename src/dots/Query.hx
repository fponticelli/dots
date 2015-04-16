package dots;

import js.html.DOMElement as Element;
import js.html.NodeList;

class Query {
  static var doc : Element = untyped __js__('document');

  public static function first(selector : String, ?ctx : Element) : Element
    return (ctx != null ? ctx : doc).querySelector(selector);

  public static function list(selector : String, ?ctx : Element) : NodeList
    return (ctx != null ? ctx : doc).querySelectorAll(selector);

  public inline static function all(selector : String, ?ctx : Element) : Array<Element>
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