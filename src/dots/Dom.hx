package dots;

import js.html.Element;
import js.html.Window;
import js.Browser.*;
import haxe.ds.Either;

class Dom {
  public static function addCss(css : String, ?container : Element) {
    if(null == container)
      container = document.head;
    var style = document.createStyleElement();
    style.type = "text/css";
    style.appendChild(document.createTextNode(css));
    container.appendChild(style);
  }

  public static function getValue(el : Element) : Null<String> {
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
  }

  public static function getMultiValue(el : Element) : Either<String, Array<String>> {
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
  }

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
}
