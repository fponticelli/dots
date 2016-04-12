package dots;

import js.html.Element;
import js.html.Node;
import js.html.NodeList;
import dots.Collections;

class Query {
  static var doc : Element = untyped __js__('document');

  public static function find<T : Element>(selector : String, ?ctx : Element) : T
    return cast (ctx != null ? ctx : doc).querySelector(selector);

  public static function selectNodes(selector : String, ?ctx : Element) : NodeList
    return (ctx != null ? ctx : doc).querySelectorAll(selector);

  public inline static function select<T : Element>(selector : String, ?ctx : Element) : Array<T>
    return cast Dom.nodeListToArray(selectNodes(selector, ctx));

  public static function getElementIndex(el : Element) {
    var index = 0;
    while(null != (el = el.previousElementSibling))
      index++;
    return index;
  }

  public static function siblings(node : Element) : Array<Element>
    return HTMLCollections.toArray((cast node.parentNode : Element).children)
      .filter(function(n : Element) return n != node);

  public static function childrenOf<T : Element>(children : Array<Element>, parent : Element) : Array<T>
    return cast children.filter(function(child) return child.parentElement == parent);
}
