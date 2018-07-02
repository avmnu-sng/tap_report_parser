require "spec_helper.rb"

RSpec.describe "#validate TAP report parsing" do
  let!(:parser) { TapReportParser::Report }
  let!(:path) { File.join(File.dirname(__FILE__), "tap_samples") }

  context "#scoring validation" do
    it "should parse all skipped test report" do
      report = parser.from_text(File.read("#{path}/all_tests_skipped.tap"))

      expect(report.test_count).to eq(0)
      expect(report.tests).to eq([])
      expect(report.passing).to eq(false)
    end

    it "should parse empty test report" do
      report = parser.from_text(File.read("#{path}/empty_report.tap"))

      expect(report.test_count).to eq(0)
      expect(report.tests).to eq([])
      expect(report.passing).to eq(false)
    end

    it "should parse no numbers test report" do
      report = parser.from_text(File.read("#{path}/no_test_numbers.tap"))

      expect(report.test_count).to eq(9)

      tests = report.tests

      expect(
        tests.map(&:number)
          .zip(tests.map(&:description))
          .zip(tests.map(&:status)).map(&:flatten)
      ).to eq(
        [
          [1, "created Board", "success"],
          [2, "", "success"],
          [3, "", "success"],
          [4, "", "success"],
          [5, "", "success"],
          [6, "", "success"],
          [7, "", "success"],
          [8, "", "success"],
          [9, "board has 7 tiles + starter tile", "success"]
        ]
      )
      expect(report.passing).to eq(true)
    end

    it "should parse only plans test report" do
      report = parser.from_text(File.read("#{path}/only_plan.tap"))

      expect(report.test_count).to eq(10)

      tests = report.tests

      expect(
        tests.map(&:number)
          .zip(tests.map(&:description))
          .zip(tests.map(&:status)).map(&:flatten)
      ).to eq(
        [
          [1, "", "failure"],
          [2, "", "failure"],
          [3, "", "failure"],
          [4, "", "failure"],
          [5, "", "failure"],
          [6, "", "failure"],
          [7, "", "failure"],
          [8, "", "failure"],
          [9, "", "failure"],
          [10, "", "failure"]
        ]
      )
      expect(report.passing).to eq(false)
    end

    it "should parse random no numbers test report" do
      report = parser.from_text(File.read("#{path}/random_missing_test_numbers.tap"))

      expect(report.test_count).to eq(6)

      tests = report.tests

      expect(
        tests.map(&:number)
          .zip(tests.map(&:description))
          .zip(tests.map(&:status)).map(&:flatten)
      ).to eq(
        [
          [1, "The object is a Board", "success"],
          [2, "Board size is zero", "success"],
          [3, "The object is a Tile", "success"],
          [4, "Get possible places to put the Tile", "success"],
          [5, "Placing the tile produces no error", "success"],
          [6, "Board size is 1", "success"]
        ]
      )
      expect(report.passing).to eq(true)
    end

    it "should parse simple test report" do
      report = parser.from_text(File.read("#{path}/simple_report.tap"))

      expect(report.test_count).to eq(6)

      tests = report.tests

      expect(
        tests.map(&:number)
          .zip(tests.map(&:description))
          .zip(tests.map(&:status)).map(&:flatten)
      ).to eq(
        [
          [1, "The object is a Board", "success"],
          [2, "Board size is zero", "success"],
          [3, "The object is a Tile", "success"],
          [4, "Get possible places to put the Tile", "success"],
          [5, "Placing the tile produces no error", "success"],
          [6, "Board size is 1", "success"]
        ]
      )
      expect(report.passing).to eq(true)
    end

    it "should parse missing tests at bottom test report" do
      report = parser.from_text(File.read("#{path}/some_missing_tests_at_bottom.tap"))

      expect(report.test_count).to eq(6)

      tests = report.tests

      expect(
        tests.map(&:number)
          .zip(tests.map(&:description))
          .zip(tests.map(&:status)).map(&:flatten)
      ).to eq(
        [
          [1, "", "failure"],
          [2, "", "success"],
          [3, "", "failure"],
          [4, "", "success"],
          [5, "", "success"],
          [6, "", "failure"]
        ]
      )
      expect(report.passing).to eq(false)
    end

    it "should parse random missing tests test report" do
      report = parser.from_text(File.read("#{path}/some_random_missing_tests.tap"))

      expect(report.test_count).to eq(6)

      tests = report.tests

      expect(
        tests.map(&:number)
          .zip(tests.map(&:description))
          .zip(tests.map(&:status)).map(&:flatten)
      ).to eq(
        [
          [1, "The object is a Board", "success"],
          [3, "The object is a Tile", "success"],
          [6, "Board size is 1", "success"],
          [2, "", "failure"],
          [4, "", "failure"],
          [5, "", "failure"]
        ]
      )
      expect(report.passing).to eq(false)
    end

    it "should parse skipped tests test report" do
      report = parser.from_text(File.read("#{path}/some_skipped_tests.tap"))

      expect(report.test_count).to eq(5)

      tests = report.tests

      expect(
        tests.map(&:number)
          .zip(tests.map(&:description))
          .zip(tests.map(&:status)).map(&:flatten)
      ).to eq(
        [
          [1, "approved operating system", "success"],
          [2, "", "skipped"],
          [3, "", "skipped"],
          [4, "", "skipped"],
          [5, "", "skipped"]
        ]
      )
      expect(report.passing).to eq(false)
    end

    it "should parse todo tests test report" do
      report = parser.from_text(File.read("#{path}/some_todo_tests.tap"))

      expect(report.test_count).to eq(4)

      tests = report.tests

      expect(
        tests.map(&:number)
          .zip(tests.map(&:description))
          .zip(tests.map(&:status)).map(&:flatten)
      ).to eq(
        [
          [1, "Creating test program", "success"],
          [2, "Test program runs, no error", "success"],
          [3, "infinite loop", "ignored"],
          [4, "infinite loop 2", "ignored"]
        ]
      )
      expect(report.passing).to eq(true)
    end

    it "should parse test count at bottom test report" do
      report = parser.from_text(File.read("#{path}/test_count_at_bottom.tap"))

      expect(report.test_count).to eq(7)

      tests = report.tests

      expect(
        tests.map(&:number)
          .zip(tests.map(&:description))
          .zip(tests.map(&:status)).map(&:flatten)
      ).to eq(
        [
          [1, "retrieving servers from the database", "success"],
          [2, "pinged diamond", "success"],
          [3, "pinged ruby", "success"],
          [4, "pinged saphire", "failure"],
          [5, "pinged onyx", "success"],
          [6, "pinged quartz", "failure"],
          [7, "pinged gold", "success"]
        ]
      )
      expect(report.passing).to eq(false)
    end

    it "should parse very simple test report" do
      report = parser.from_text(File.read("#{path}/very_simple_report.tap"))

      expect(report.test_count).to eq(4)

      tests = report.tests

      expect(
        tests.map(&:number)
          .zip(tests.map(&:description))
          .zip(tests.map(&:status)).map(&:flatten)
      ).to eq(
        [
          [1, "Input file opened", "success"],
          [2, "First line of the input valid", "failure"],
          [3, "Read the rest of the file", "success"],
          [4, "Summarized correctly", "failure"]
        ]
      )
      expect(report.passing).to eq(false)
    end
  end

  context "#diagnostic validation" do
    it "should parse all skipped test report" do
      report = parser.from_file("#{path}/all_tests_skipped.tap")

      expect(report.tests.map(&:diagnostic).count("")).to eq(0)
    end

    it "should parse empty test report" do
      report = parser.from_file("#{path}/empty_report.tap")

      expect(report.tests.map(&:diagnostic).count("")).to eq(0)
    end

    it "should parse no numbers test report" do
      report = parser.from_file("#{path}/no_test_numbers.tap")

      target = report.tests.find { |t| t.number == 8 }.diagnostic || ""

      expect(target).to eq(
        {
          "message" => "Board layout",
          "severity" => "comment",
          "dump" => {
            "board" => [
              "      16G         05C        ",
              "      G N C       C C G      ",
              "        G           C  +     ",
              "10C   01G         03C        ",
              "R N G G A G       C C C      ",
              "  R     G           C  +     ",
              "      01G   17C   00C        ",
              "      G A G G N R R N R      ",
              "        G     R     G        "
            ]
          }
        }
      )
    end

    it "should parse only plans test report" do
      report = parser.from_file("#{path}/only_plan.tap")

      expect(report.tests.map(&:diagnostic).count("")).to eq(10)
    end

    it "should parse random no numbers test report" do
      report = parser.from_file("#{path}/random_missing_test_numbers.tap")

      expect(report.tests.map(&:diagnostic).count("")).to eq(6)
    end

    it "should parse simple test report" do
      report = parser.from_file("#{path}/simple_report.tap")

      expect(report.tests.map(&:diagnostic).count("")).to eq(6)
    end

    it "should parse missing tests at bottom test report" do
      report = parser.from_file("#{path}/some_missing_tests_at_bottom.tap")

      expect(report.tests.map(&:diagnostic).count("")).to eq(6)
    end

    it "should parse random missing tests test report" do
      report = parser.from_file("#{path}/some_random_missing_tests.tap")

      expect(report.tests.map(&:diagnostic).count("")).to eq(6)
    end

    it "should parse skipped tests test report" do
      report = parser.from_file("#{path}/some_skipped_tests.tap")

      tests = report.tests
      expect(tests.map(&:diagnostic).count("")).to eq(4)

      target = tests.find { |t| t.number == 1 }.diagnostic || ""
      expect(target).to eq("$^0 is solaris")
    end

    it "should parse todo tests test report" do
      report = parser.from_file("#{path}/some_todo_tests.tap")

      expect(report.tests.map(&:diagnostic).count("")).to eq(4)
    end

    it "should parse test count at bottom test report" do
      report = parser.from_file("#{path}/test_count_at_bottom.tap")

      tests = report.tests

      target = tests.find { |t| t.number == 1 }.diagnostic || ""
      expect(target).to eq("need to ping 6 servers")

      target = tests.find { |t| t.number == 4 }.diagnostic || ""
      expect(target).to eq(
        {
          "message" => "hostname \"saphire\" unknown",
          "severity" => "fail"
        }
      )

      target = tests.find { |t| t.number == 6 }.diagnostic || ""
      expect(target).to eq(
        {
          "message" => "timeout",
          "severity" => "fail"
        }
      )
    end

    it "should parse very simple test report" do
      report = parser.from_file("#{path}/very_simple_report.tap")

      expect(report.tests.map(&:diagnostic).count("")).to eq(4)
    end
  end
end
