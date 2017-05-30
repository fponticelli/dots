package dots;

#if !macro
import js.html.Document;
import js.html.HTMLDocument;
import js.html.Element;
import js.html.Event;
import js.html.Node;
import js.html.NodeList;
import js.html.Window;
import js.Browser.*;
import haxe.ds.Either;
using thx.Arrays;
#else
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.MacroStringTools;
#end

class Dom {
  macro public static function create(args: Array<Expr>) {
  // name : String, ?attrs : Map<String, String>, ?children : Array<Node>, ?textContent : String, ?doc : Document
    var name = args[0];
    var attrs = macro null;
    var children = macro null;
    var textContent = macro null;
    var doc = macro null;
    for(i in 1...args.length) {
      switch Context.typeof(args[i]) {
        case TInst(c, _) if(c.toString() == "String"):
          textContent = args[i];
        case TAbstract(a, [TInst(k, _), TInst(v, _)]) if(a.toString() == "Map" && k.toString() == "String" && v.toString() == "String"):
          attrs = args[i];
        case TInst(a, [TInst(e, _)]) if(a.toString() == "Array" && (e.toString() == "js.html.Node" || e.toString() == "js.html.Element")):
          children = args[i];
        case TInst(c, _) if(c.toString() == "js.html.Document"):
          doc = args[i];
        case TInst(a, [TMono(_)]) if(a.toString() == "Array"):
          // most likely an empty array, do nothing
        case other:
          Context.error('invalid argument type: $other', Context.currentPos());
      }
    }

    switch name.expr {
      case EConst(CString(s)) if(Type.enumConstructor(MacroStringTools.formatString(s, name.pos).expr) == "EConst"):
        var node = try SelectorParser.parseSelector(s) catch(e: Dynamic) {
          trace(e);
          Context.error('$e', Context.currentPos());
        };
        var tag = node.tag,
            attributes = [];
        for(name in node.attributes.keys()) {
          attributes.push({ name : name, value : node.attributes.get(name) });
        }
        return macro ({
          var doc: js.html.Document = $doc;
          if(null == doc) doc = js.Browser.document;
          var el = doc.createElement($v{tag});
          for(o in $v{attributes})
            el.setAttribute(o.name, o.value);
          var attrs: Map<String, String> = $attrs;
          if(null != attrs) {
            for(attr in attrs.keys())
              el.setAttribute(attr, attrs.get(attr));
          }
          var children: Array<Dynamic> = $children;
          if(null != children)
            for(child in children)
              el.appendChild(child);
          var textContent = $textContent;
          if(null != textContent)
            el.appendChild(doc.createTextNode(textContent));
          el;
        } : js.html.Element);
      case other:
        return macro dots.Dom.parse($name, $attrs, $children, $textContent, $doc);
    }
    // if(null == doc) doc = document;
    // var el = doc.createElement(node.tag);
    // for(key in node.attributes.keys()) {
    //   Attributes.setStringAttribute(el, key, node.attributes.get(key));
    // }
    // if(null != children)
    //   for(child in children)
    //     el.appendChild(child);
    // if(null != textContent)
    //   el.appendChild(doc.createTextNode(textContent));
  }

#if !macro
  // class
  inline public static function hasClass(el : Element, className : String)
    return el.classList.contains(className);

  inline public static function addClass(el : Element, className : String) {
    el.classList.add(className);
    return el;
  }

  inline public static function removeClass(el : Element, className : String) {
    el.classList.remove(className);
    return el;
  }

  public static function remove(node: Node): Node {
    var parentNode = node.parentNode;
    parentNode.removeChild(node);
    return parentNode;
  }

  public static function toggleClass(el: Element, className: String, ?condition: Bool) {
    if(null == condition)
      condition = !hasClass(el, className);
    if(condition) {
      addClass(el, className);
    } else {
      removeClass(el, className);
    }
  }

  // events
  inline public static function on(el : Element, eventName : String, handler : EventHandler) {
    el.addEventListener(eventName, handler.toCallback());
    return el;
  }

  public static function once(el : Element, eventName : String, handler : EventHandler) {
    function f(e) {
      el.removeEventListener(eventName, f);
      handler(e);
    }
    el.addEventListener(eventName, f);
    return el;
  }

  inline public static function off(el : Element, eventName : String, handler : Event -> Void) {
    el.removeEventListener(eventName, handler);
    return el;
  }

  // utilities
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

  public static function nodeText(node : Node) : String
    return if(node.nodeType == Node.ELEMENT_NODE) {
      (cast node : Element).innerHTML;
    } else if(node.nodeType ==  Node.COMMENT_NODE) {
      return node.textContent;
    } else if(node.nodeType ==  Node.TEXT_NODE) {
      return node.textContent;
    } else {
      throw new thx.Error('invalid nodeType ${node.nodeType}');
    };

  // elements
  public inline static function nodeListToArray(list : NodeList) : Array<Element>
    return untyped __js__('Array.prototype.slice.call')(list, 0);

  public static function parse(name : String, ?attrs : Map<String, String>, ?children : Array<Node>, ?textContent : String, ?doc : Document) : Element {
    var node = SelectorParser.parseSelector(name, attrs);
    if(null == doc) doc = document;
    var el = doc.createElement(node.tag);
    for(key in node.attributes.keys()) {
      Attributes.setStringAttribute(el, key, node.attributes.get(key));
    }
    if(null != children)
      for(child in children)
        el.appendChild(child);
    if(null != textContent)
      el.appendChild(doc.createTextNode(textContent));
    return el;
  }

  public static function insertAtIndex(el : Element, child : Node, index : Int) {
    el.insertBefore(child, el.children[index]);
    return el;
  }

  static function prependChild(el : Element, child : Node) {
    return insertAtIndex(el, child, 0);
  }

  static function prependChildren(el : Element, children : Array<Node>) : Element
    return children.reduceRight(prependChild, el);

  public static function prepend(el : Element, ?child : Node, ?children : Array<Node>) : Element {
    if (child != null)
      prependChild(el, child);
    return prependChildren(el, children != null ? children : []);
  }

  static function appendChild(el : Element, child : Node) : Element {
    el.appendChild(child);
    return el;
  }

  static function appendChildren(el : Element, children : Array<Node>) : Element
    return children.reduce(appendChild, el);

  public static function append(el : Element, ?child : Node, ?children : Array<Node>) : Element {
    if (child != null)
      appendChild(el, child);
    if (children != null && children.length > 0)
      appendChildren(el, children);
    return el;
  }

  public static function empty(el : Element) {
    while (el.firstChild != null)
      el.removeChild(el.firstChild);
    return el;
  }

  static function flattenSiblingsAndChildren(node : Node) {
    while(node != null) {
      if(node.nodeType == Node.ELEMENT_NODE) {
        flattenSiblingsAndChildren(node.childNodes[0]);
      } else if(node.nodeType == Node.TEXT_NODE) {
        while(null != node.nextSibling && node.nextSibling.nodeType == Node.TEXT_NODE) {
          var a = node.textContent,
              b = node.nextSibling.textContent;
          node.parentNode.removeChild(node.nextSibling);
          var t = js.Browser.document.createTextNode(a + b);
          node.parentNode.replaceChild(t, node);
          node = t;
        }
      }
      node = node.nextSibling;
    }
  }

  public static function flattenTextNodes(dom : Element)
    flattenSiblingsAndChildren(dom.childNodes[0]);

  public static function traverseTextNodes(dom : Element, f : Node -> Void) {
    var collect : Array<Node> = [];
    function perform(dom : Node) {
      if(dom.nodeType == Node.TEXT_NODE) {
        collect.push(dom);
      } else if(dom.nodeType == Node.ELEMENT_NODE) {
        for(child in dom.childNodes)
          perform(child);
      }
    }
    perform(dom);
    for(n in collect) f(n);
  }

  // css
  public static function addCss(css : String, ?container : Element) {
    if(null == container)
      container = document.head;
    var style = document.createStyleElement();
    style.type = "text/css";
    style.appendChild(document.createTextNode(css));
    container.appendChild(style);
  }

  // properties and attributes
  public static function getValue(el : Element) : Null<String>
    return switch el.nodeName {
      case "INPUT":
        var input : js.html.InputElement = cast el;
        if (input.type == "checkbox" && !input.checked) null;
        else input.value;
      case "TEXTAREA":
        var textarea : js.html.TextAreaElement = cast el;
        textarea.value;
      case "SELECT":
        var select : js.html.SelectElement = cast el,
        option : js.html.OptionElement = cast select.options.item(select.selectedIndex);
        option.value;
      case _:
        el.innerHTML;
      };

  public static function getMultiValue(el : Element) : Either<String, Array<String>>
    return switch el.nodeName {
      case "INPUT":
        var input : js.html.InputElement = cast el;
        if (input.type == "checkbox" && !input.checked) Right([]);
        else Left(input.value);
      case "TEXTAREA":
        var textarea : js.html.TextAreaElement = cast el;
        Left(textarea.value);
      case "SELECT":
        var select : js.html.SelectElement = cast el;
        if (select.multiple) {
          var values = [];
          var options = select.selectedOptions;
          for(i in 0...options.length)
            values.push((cast options[i] : js.html.OptionElement).value);

          Right(values);
        }
        else {
          var option : js.html.OptionElement = cast select.options.item(select.selectedIndex);
          Left(option.value);
        }

      case _:
        Left(el.innerHTML);
    };

  public static function getWindowHeight(?win : Window) : Int {
    if(null == win) win = window;
    return win.document.documentElement.clientHeight;
  }

  public static function getWindowWidth(?win : Window) : Int {
    if(null == win) win = window;
    return win.document.documentElement.clientWidth;
  }

  public static function getWindowSize(?win : Window) : { width : Int, height : Int } {
    if(null == win) win = window;
    return { width : win.document.documentElement.clientWidth, height : win.document.documentElement.clientHeight };
  }

  public static function getWindowInnerHeight(?win : Window) : Int {
    if(null == win) win = window;
    return win.innerHeight;
  }

  public static function getWindowInnerWidth(?win : Window) : Int {
    if(null == win) win = window;
    return win.innerWidth;
  }

  public static function getWindowInnerSize(?win : Window) : { width : Int, height : Int } {
    if(null == win) win = window;
    return { width : win.innerWidth, height : win.innerHeight };
  }

  public static function getDocumentHeight(?doc : Document) : Int {
    if(null == doc) doc = document;
    return doc.documentElement.scrollHeight;
  }

  public static function getDocumentWidth(?doc : Document) : Int {
    if(null == doc) doc = document;
    return doc.documentElement.scrollWidth;
  }

  public static function getDocumentSize(?doc : Document) : { width : Int, height : Int } {
    if(null == doc) doc = document;
    return { width : doc.documentElement.scrollWidth, height : doc.documentElement.scrollHeight };
  }

  public static function getScrollTop(?doc : HTMLDocument) {
    if(null == doc) doc = document;
    if(null != doc.documentElement)
      return doc.documentElement.scrollTop;
    else
      return doc.body.scrollTop;
  }

  public static function getOffset(el : Element, ?doc : HTMLDocument) {
    if(null == doc) doc = document;
    var rect = el.getBoundingClientRect();
    return {
      top: Math.round(rect.top + doc.body.scrollTop),
      left: Math.round(rect.left + doc.body.scrollLeft)
    };
  }

  public static function getOffsetParent(el : Element)
    return null != el.offsetParent ? el.offsetParent : el;

  public static function getOuterHeight(el : Element)
    return el.getBoundingClientRect().height;

  inline public static function getOffsetHeight(el : Element)
    return el.offsetHeight;

  public static function getOuterHeightWithMargin(el : Element) {
    var h = el.offsetHeight,
        s = Style.style(el);
    return h + Std.parseInt(s.marginTop) + Std.parseInt(s.marginBottom);
  }

  public static function getOuterWidth(el : Element)
    return el.getBoundingClientRect().width;

  inline public static function getOffsetWidth(el : Element)
    return el.offsetWidth;

  public static function getOuterWidthWithMargin(el : Element) {
    var h = el.offsetWidth,
        s = Style.style(el);
    return h + Std.parseInt(s.marginLeft) + Std.parseInt(s.marginRight);
  }

  inline public static function getPosition(el : Element)
    return { left: el.offsetLeft, top: el.offsetTop };

  public static function ready(fn : Void -> Void, doc : Document) {
    if(null == doc) doc = document;
    if (doc.readyState != 'loading'){
      fn();
    } else {
      doc.addEventListener('DOMContentLoaded', fn);
    }
  }

  static function __init__() {
#if polyfill
    haxe.macro.Compiler.includeFile("src/dots/classList.js");
    haxe.macro.Compiler.includeFile("src/dots/eventListener.js");
#end
  }
#end
}
