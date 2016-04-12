package dots;

import js.html.Element;
import js.html.Event;
import thx.Floats;
import thx.Ints;

@:callable
abstract EventHandler(Event -> Void) {
  @:from inline static public function fromHandler(f : Void -> Void) : EventHandler
    return function(e : Event) {
      e.preventDefault();
      f();
    };

  @:from inline static public function fromEventHandler<T : Event>(f : T -> Void) : EventHandler
    return cast f;

  @:from inline static public function fromElementHandler<T : Element>(f : T -> Void) : EventHandler
    return function(e : Event) {
      e.preventDefault();
      var input : T = cast e.target;
      f(input);
    };

  @:from inline static public function fromStringValueHandler(f : String -> Void) : EventHandler
    return function(e : Event) {
      e.preventDefault();
      var value : String = dots.Dom.getValue(cast e.target);
      f(value);
    };

  @:from inline static public function fromBoolValueHandler(f : Bool -> Void) : EventHandler
    return function(e : Event) {
      e.preventDefault();
      var value : Bool = (cast e.target : js.html.InputElement).checked;
      f(value);
    };

  @:from inline static public function fromIntValueHandler(f : Int -> Void) : EventHandler
    return fromStringValueHandler(function(s : String) {
      if(Ints.canParse(s)) f(Ints.parse(s));
    });

  @:from inline static public function fromFloatValueHandler(f : Float -> Void) : EventHandler
    return fromStringValueHandler(function(s : String) {
      if(Floats.canParse(s)) f(Floats.parse(s));
    });

  inline public function toCallback() : Event -> Void
    return this;
}
