package dots;

import js.html.Element;
import js.Browser.*;

class Dom {
  public static function addCss(css : String, ?container : Element) {
    if(null == container)
      container = document.head;
    var style = document.createStyleElement();
    style.type = "text/css";
    style.appendChild(document.createTextNode(css));
    container.appendChild(style);
  }

  public static function getValue(el : Element)
    return switch el.nodeName {
      case "input":
        var input : js.html.InputElement = cast el;
        input.value;
      case "textarea":
        var textarea : js.html.TextAreaElement = cast el;
        textarea.value;
      case "select":
        var select : js.html.SelectElement = cast el,
            option : js.html.OptionElement = cast select.options.item(select.selectedIndex);
        option.value;
      case _:
        el.innerHTML;
    };
}
