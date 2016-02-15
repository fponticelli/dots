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
    return nodeListToArray(parseNodes(html));

  public static function parseElement(html : String) : Element
    return cast parseNodes(html)[0];

  public static function parse(html : String) : Node {
    var nodes = parseNodes(html);
    if(nodes.length > 1) {
      var doc = js.Browser.document.createDocumentFragment();
      for(node in nodes)
        doc.appendChild(node);
      return doc;
    } else {
      return nodes[0];
    }
  }

  public static function toString(node : Node) : String
    return if(node.nodeType == Node.ELEMENT_NODE) {
      (cast node : Element).outerHTML;
    } else if(node.nodeType ==  Node.COMMENT_NODE) {
      return '<!--${node.textContent}-->';
    } else if(node.nodeType ==  Node.TEXT_NODE) {
      return node.textContent;
    } else {
      throw new thx.Error('invalid nodeType ${node.nodeType}');
    };

/*
} else if(node.nodeType ==  Node.CDATA_SECTION_NODE) {
} else if(node.nodeType ==  Node.DOCUMENT_FRAGMENT_NODE) {
} else if(node.nodeType ==  Node.DOCUMENT_NODE) {
} else if(node.nodeType ==  Node.DOCUMENT_TYPE_NODE) {
} else if(node.nodeType ==  Node.PROCESSING_INSTRUCTION_NODE) {
*/

  public inline static function nodeListToArray(list : NodeList) : Array<Element>
    return untyped __js__('Array.prototype.slice.call')(list, 0);
}
