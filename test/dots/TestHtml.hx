package dots;

import utest.Assert;

class TestHtml {
  public function new() {}

  public function testParseLI() {
    var li = Html.parseElement("<li></li>");
    Assert.equals("LI", li.tagName);
  }

  public function testParseTD() {
    var td = Html.parseElement("<td></td>");
    Assert.equals("TD", td.tagName);
  }

  public function testParseTR() {
    var tr = Html.parseElement("<tr></tr>");
    Assert.equals("TR", tr.tagName);
  }

  public function testParseTBODY() {
    var tbody = Html.parseElement("<tbody></tbody>");
    Assert.equals("TBODY", tbody.tagName);
  }

  public function testParseTHEAD() {
    var thead = Html.parseElement("<thead></thead>");
    Assert.equals("THEAD", thead.tagName);
  }
}
