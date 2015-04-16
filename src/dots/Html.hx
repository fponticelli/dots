package dots;

using StringTools;
import js.Browser;
import js.html.DOMElement as Element;
import js.html.Node;
import js.html.NodeList;

class Html {
  static var pattern = ~/[<]([^> ]+)/;
  public static function parseNodes(html : String) : NodeList {
    if(!pattern.match(html))
      throw 'Invalid pattern "$html"';
    var el = switch pattern.matched(1).toLowerCase() {
      case "tbody",
           "thead": Browser.document.createElement("table");
      case "td",
           "th": Browser.document.createElement("tr");
      case "tr": Browser.document.createElement("tbody");
      case _:    Browser.document.createElement("div");
    };
    el.innerHTML = html;
    return el.childNodes;
  }

  public inline static function parseArray(html : String) : Array<Element>
    return nodeListToArray(parseNodes(html));

  public inline static function parse(html : String) : Element
    return cast parseNodes(html)[0];

  public inline static function nodeListToArray(list : NodeList) : Array<Element>
    return untyped __js__('Array.prototype.slice.call')(list, 0);
}