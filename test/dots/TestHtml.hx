package dots;

import utest.Assert;

class TestHtml {
  public function new() {}

  public function testParseLI() {
    var li = Html.parse("<li></li>");
    Assert.equals("LI", li.tagName);
  }

  public function testParseTD() {
    var td = Html.parse("<td></td>");
    Assert.equals("TD", td.tagName);
  }

  public function testParseTR() {
    var tr = Html.parse("<tr></tr>");
    Assert.equals("TR", tr.tagName);
  }

  public function testParseTBODY() {
    var tbody = Html.parse("<tbody></tbody>");
    Assert.equals("TBODY", tbody.tagName);
  }

  public function testParseTHEAD() {
    var thead = Html.parse("<thead></thead>");
    Assert.equals("THEAD", thead.tagName);
  }
}