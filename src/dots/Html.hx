package dots;

using StringTools;
import js.Browser;
import js.html.Element;
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
    return Dom.nodeListToArray(parseNodes(html));

  public static function parseElement(html : String) : Element
    return cast parseNodes(html)[0];

  public static function parse(html : String) : Node {
    var nodes = parseNodes(html);
    if(nodes.length > 1) {
      var doc = js.Browser.document.createDocumentFragment();
      while(nodes.length > 0)
        doc.appendChild(nodes[0]);
      return doc;
    } else {
      return nodes[0];
    }
  }
}
