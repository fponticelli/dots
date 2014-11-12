package dots;

import js.Browser;

class Detect {
  public static function supportsInput(type : String) {
    var i = Browser.document.createInputElement();
    i.setAttribute("type", type);
    return i.type == type;
  }

  public static function supportsInputPlaceholder() {
    var i = Browser.document.createInputElement();
    return Reflect.hasField(i, "placeholder");
  }

  public static function supportsInputAutofocus() {
    var i = Browser.document.createInputElement();
    return Reflect.hasField(i, "autofocus");
  }

  public static function supportsCanvas() : Bool
    return null != Browser.document.createCanvasElement().getContext;

  public static function supportsVideo() : Bool
    return null != Browser.document.createVideoElement().canPlayType;

  public static function supportsLocalStorage() : Bool
    return try {
      untyped __js__("'localStorage' in window && window['localStorage'] !== null");
    } catch(e : Dynamic) false;

  public static function supportsWebWorkers() : Bool
    return untyped !!js.Browser.window.Worker;

  public static function supportsOffline() : Bool
    return null != js.Browser.window.applicationCache;

  public static function supportsGeolocation() : Bool
    return Reflect.hasField(Browser.navigator, "geolocation");

  public static function supportsMicrodata() : Bool
    return Reflect.hasField(Browser.document, "getItems");

  public static function supportsHistory() : Bool
    return untyped __js__("!!(window.history && history.pushState)");
}