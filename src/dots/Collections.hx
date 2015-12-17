package dots;

import js.html.Element;
import js.html.HTMLCollection;
import js.html.Node;
import js.html.NodeList;

class HTMLCollections {
  inline public static function toArray<T : Element>(it : HTMLCollection) : Array<Element>
    return untyped __js__("Array.prototype.slice.call")(it);
}

class NodeLists {
  inline public static function toArray<T : Node>(it : NodeList) : Array<Node>
    return untyped __js__("Array.prototype.slice.call")(it);
}
