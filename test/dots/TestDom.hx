package dots;

import utest.Assert;
using dots.Dom;

class TestDom {
  public function new() {}

  public function testToggleClass() {
    var div = Html.parseElement("<div></div>");
    Assert.isFalse(div.hasClass("test"));
    div.toggleClass("test");
    Assert.isTrue(div.hasClass("test"));
    div.toggleClass("test", false);
    Assert.isFalse(div.hasClass("test"));
    div.toggleClass("test", true);
    Assert.isTrue(div.hasClass("test"));
    div.toggleClass("test");
    Assert.isFalse(div.hasClass("test"));
  }

  public function testCreate() {
    // test macro-time
    var div = Dom.create('div.myclass', 'content');
    Assert.equals("DIV", div.tagName);
    Assert.isTrue(div.hasClass("myclass"));
    Assert.equals("content", div.textContent);

    // name : String, ?attrs : Map<String, String>, ?children : Array<Node>, ?textContent : String, ?doc : Document
    div = Dom.create('div.some', ["some" => "value"], [div], 'content');
    Assert.isTrue(div.hasClass("some"));
    Assert.equals("value", div.getAttribute("some"));
    Assert.isTrue(div.children.length == 1);
    Assert.equals("contentcontent", div.textContent);

    // with string interpolation
    var cls = "abc";
    div = Dom.create('div.$cls');
    Assert.isTrue(div.hasClass("abc"));

    // test runtime
    var def = function() return 'div.myclass',
        con = function() return 'content';
    div = Dom.create(def(), con());
    Assert.isTrue(div.hasClass("myclass"));
    Assert.equals("content", div.textContent);
  }
}
