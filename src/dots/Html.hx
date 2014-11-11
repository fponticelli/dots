package dots;

using StringTools;
import js.html.Element;
import js.html.Node;
import js.html.NodeList;

class Html {
  public static function parseNodes(html : String) : NodeList {
    var el = js.Browser.document.createElement('div');
    el.innerHTML = html;
    return el.childNodes;
  }

  public inline static function parseArray(html : String) : Array<Element>
    return nodeListToArray(parseNodes(html.trim()));

  public inline static function parse(html : String) : Element
    return cast parseNodes(html.ltrim())[0];

  public inline static function nodeListToArray(list : NodeList) : Array<Element>
    return untyped __js__('Array.prototype.slice.call')(list, 0);
}