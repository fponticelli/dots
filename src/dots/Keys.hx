package dots;

import haxe.ds.Option;
using thx.Arrays;
using thx.Options;
using thx.Strings;

typedef KeyWithModifiers = {
  key: Key,
  modifiers: Array<Modifier>
};

enum Key {
  Printing(char: thx.Char, isNumPad: IsNumpad); // `Unknown` if browser doesn't provide `event.code`
  NamedPrinting(namedChar: NamedCharacter);
  NonPrinting(key: NonPrinting);
  Unknown(key: Option<String>, code: Option<String>, keyCode: Option<Int>, which: Option<Int>);
}

enum NamedCharacter {
  Multiply;
  Add;
  Subtract;
  DecimalPoint;
  Divide;
  Tab;
  Enter;
  Backspace;
  Delete;
}

enum IsNumpad {
  Numpad;
  NotNumpad;
  Unknown;
}

enum MetaOrOS {
  Meta;
  OS;
}

enum LeftOrRight {
  Left;
  Right;
  NA;
  Unknown;
}

enum NonPrinting {
  Break;
  Escape;
  PageUp;
  PageDown;
  End;
  Home;
  LeftArrow;
  UpArrow;
  RightArrow;
  DownArrow;
  Insert;
  F(number: Int);
  Select;
  ContextMenu;
  NumLock;
  Modifier(mod: Modifier, leftOrRight: LeftOrRight);
}

enum Modifier {
  Alt;
  CapsLock;
  Control;
  MetaOrOS(which: MetaOrOS);
  ScrollLock;
  Shift;
}

class Keys {
  public static function getKeyAndModifiers(evt: js.html.KeyboardEvent): KeyWithModifiers {
    return {
      key: getKey(evt),
      modifiers: getModifiers(evt)
    };
  }

  public static function getKey(evt: js.html.KeyboardEvent): Key {
    var evtCode: Null<String> = untyped evt.code;

    return Options.ofValue(evt.key)
      .flatMap(fromEventKey.bind(Options.ofValue(evtCode)))
      .orElse(
        Options.ofValue(evt.which).orElse(Options.ofValue(evt.keyCode))
          .flatMap(fromEventCode)
      )
      .getOrElse(Unknown(Options.ofValue(evt.key), Options.ofValue(evtCode), Options.ofValue(evt.keyCode), Options.ofValue(evt.which)));
  }

  static function leftOrRight(code: Option<String>): LeftOrRight {
    return switch code {
      case Some(v) if (v.endsWith("Left")): Left;
      case Some(v) if (v.endsWith("Right")): Right;
      case _: Unknown;
    }
  }

  public static function getModifiers(evt: js.html.KeyboardEvent): Array<Modifier> {
    var mappings = [
      { modifier: Alt, names: ["Alt"] },
      { modifier: CapsLock, names: ["CapsLock"] },
      { modifier: MetaOrOS(Meta), names: ["Meta"] },
      { modifier: MetaOrOS(OS), names: ["OS"] },
      { modifier: ScrollLock, names: ["ScrollLock"] },
      { modifier: Shift, names: ["Shift"] }
    ];
    return mappings.reduce(
      function (acc: Array<Modifier>, curr) return curr.names.any(code -> evt.getModifierState(code)) ? acc.concat([curr.modifier]) : acc,
      ([]: Array<Modifier>)
    );
  }

  /**
   *  Given an event code and an event key, try to figure out what kind of key was pressed,
   *  returning `None` if no known keys match.
   *  @param code - from event.code, optional because it isn't available in some browsers
   *  @param key - from event.key, a string representation of the key press
   *  @return Option<Key>
   */
  public static function fromEventKey(code: Option<String>, key: String): Option<Key> {
    return switch key {
      // non-printing characters
      case "Backspace": Some(NamedPrinting(Backspace));
      case "Tab": Some(NamedPrinting(Tab));
      case "Enter": Some(NamedPrinting(Enter));
      case "Break" | "Pause": Some(NonPrinting(Break));
      case "Escape": Some(NonPrinting(Escape));
      case "PageUp": Some(NonPrinting(PageUp));
      case "PageDown": Some(NonPrinting(PageDown));
      case "End": Some(NonPrinting(End));
      case "Home": Some(NonPrinting(Home));
      case "ArrowLeft": Some(NonPrinting(LeftArrow));
      case "ArrowUp": Some(NonPrinting(UpArrow));
      case "ArrowRight": Some(NonPrinting(RightArrow));
      case "ArrowDown": Some(NonPrinting(DownArrow));
      case "Insert": Some(NonPrinting(Insert));
      case "Delete": Some(NamedPrinting(Delete));
      case "Select": Some(NonPrinting(Select));
      case "ContextMenu" | "Apps": Some(NonPrinting(ContextMenu));
      case "NumLock": Some(NonPrinting(NumLock));
      case "CapsLock": Some(NonPrinting(Modifier(CapsLock, NA)));
      case "ScrollLock": Some(NonPrinting(Modifier(ScrollLock, NA)));

      case "Alt": Some(NonPrinting(Modifier(Alt, leftOrRight(code))));
      case "Shift": Some(NonPrinting(Modifier(Shift, leftOrRight(code))));
      case "Control": Some(NonPrinting(Modifier(Control, leftOrRight(code))));
      case "Meta": Some(NonPrinting(Modifier(MetaOrOS(Meta), leftOrRight(code))));
      case "OS" | "Win": Some(NonPrinting(Modifier(MetaOrOS(OS), leftOrRight(code))));

      case some if (some.substring(0, 1) == "F" && thx.Ints.canParse(some.substring(1))):
        Some(NonPrinting(F(thx.Ints.parse(some.substring(1)))));

      case char if (char.length == 1):
        switch code {
          case None: Some(Printing(char, Unknown));
          case Some(c) if (c.startsWith("Numpad")): Some(Printing(char, Numpad));
          case Some(_): Some(Printing(char, NotNumpad));
        }

      case _: None;
    };
  }

  public static function fromEventCode(code: Int): Option<Key> {
    return switch code {

      case 8: Some(NamedPrinting(Backspace));
      case 9: Some(NamedPrinting(Tab));
      case 13: Some(NamedPrinting(Enter));
      case 19: Some(NonPrinting(Break));
      case 27: Some(NonPrinting(Escape));
      case 33: Some(NonPrinting(PageUp));
      case 34: Some(NonPrinting(PageDown));
      case 35: Some(NonPrinting(End));
      case 36: Some(NonPrinting(Home));
      case 37: Some(NonPrinting(LeftArrow));
      case 38: Some(NonPrinting(UpArrow));
      case 39: Some(NonPrinting(RightArrow));
      case 40: Some(NonPrinting(DownArrow));
      case 45: Some(NonPrinting(Insert));
      case 46: Some(NamedPrinting(Delete));
      case 144: Some(NonPrinting(NumLock));
      case 16: Some(NonPrinting(Modifier(Shift, Unknown)));
      case 17: Some(NonPrinting(Modifier(Control, Unknown)));
      case 18: Some(NonPrinting(Modifier(Alt, Unknown)));
      case 20: Some(NonPrinting(Modifier(CapsLock, Unknown)));
      case 145: Some(NonPrinting(Modifier(ScrollLock, Unknown)));
      case 91: Some(NonPrinting(Modifier(MetaOrOS(Meta), Left))); // untested on Linux, but should report "Meta"
      case 92: Some(NonPrinting(Modifier(MetaOrOS(Meta), Right))); // unconfirmed, because this might not exist anymore?
      case 93: Some(NonPrinting(Select));

      case 106: Some(NamedPrinting(Multiply));
      case 107: Some(NamedPrinting(Add));
      case 109: Some(NamedPrinting(Subtract));
      case 110: Some(NamedPrinting(DecimalPoint));
      case 111: Some(NamedPrinting(Divide));

      case fn if (fn >= 112 && fn <= 130): Some(NonPrinting(F(fn - 111)));
      case np if (np >= 96 && np <= 105): Some(Printing(np - 96, Numpad));

      // otherwise, just try to convert the code into a UTF8 char,
      // which might be wrong, but you only got here because your browser is ancient
      case v if ((v >= 32 && v<= 127) || v >= 160): Some(Printing(thx.Char.fromInt(v), Unknown));
      case _: None;
    };
  }
}
