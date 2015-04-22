package dots;

import js.html.DOMElement;
import js.Browser.*;

class Dom {
  public static function addCss(css : String, ?container : DOMElement) {
    if(null == container)
      container = document.head;
    var style = document.createStyleElement();
    style.type = "text/css";
    style.appendChild(document.createTextNode(css));
    container.appendChild(style);
  }
}
