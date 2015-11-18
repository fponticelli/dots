import utest.ui.Report;
import utest.Runner;

class TestAll {
  static function main() {
    var runner = new Runner();

    runner.addCase(new dots.TestHtml());

    Report.create(runner);
    runner.run();
  }
}
