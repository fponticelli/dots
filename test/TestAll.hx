import utest.ui.Report;
import utest.Runner;

class TestAll {
  static function main() {
    var runner = new Runner();

    runner.addCase(new dots.TestDom());
    runner.addCase(new dots.TestHtml());
    runner.addCase(new dots.TestSelectorParser());

    Report.create(runner);
    runner.run();
  }
}
