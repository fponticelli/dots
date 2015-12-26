package dots;

import js.html.Element;
import js.html.CSSStyleDeclaration;

class Style {
  public static function style(el : Element) : CSSStyleDeclaration {
    var window = el.ownerDocument.defaultView;
    return window.getComputedStyle(el, null);
  }
}
