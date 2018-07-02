require "active_support/core_ext/object/blank"
require "yaml"
require "tap_report_parser/version"

module TapReportParser
  class Report
    attr_reader :test_count, :tests, :passing

    def initialize(report)
      @report = report
      @test_count = 0
      @tests = []
    end

    def self.from_file(file)
      parser = Report.new(File.read(file))
      parser.parse_report

      parser
    end

    def self.from_text(text)
      parser = Report.new(text)
      parser.parse_report

      parser
    end

    def parse_report
      test_number = 1

      @report.strip.split("\n").each do |line|
        test_number = parse_line(line, test_number)
      end

      if @test_count != 0
        ((1..@test_count).to_a - @tests.map(&:number)).each do |num|
          @tests << Test.new("failure", num, "", "")
        end
      else
        @test_count = @tests.count
      end

      @passing = @test_count != 0 && @tests.map(&:passing).count(true) == @test_count
      @tests.each { |test| test.convert_diagnostic_yaml_to_hash }
    end

    def parse_line(line, test_number)
      test_count = /1\.\.(\d+)(\s*#\s*.*)?/.match(line)&.captures&.first.to_i

      if test_count != 0
        @test_count = test_count

        return test_number
      end

      matches = /^(ok|not ok)\s*(\d*)\s*-?\s*([^#]*)\s*(#\s*(.*))?/.match(line)&.captures&.map(&:to_s)

      if matches.present?
        matches = matches.map(&:strip)

        matches[0] = matches[0] == "ok" ? "success" : "failure"
        matches[1] = matches[1].present? ? matches[1].to_i : test_number

        @tests << Test.new(matches[0], matches[1], matches[2], matches[4])

        return matches[1] + 1
      end

      diagnostic = /^(#\s*)?(.*)$/.match(line)&.captures&.last&.rstrip

      @tests.last.add_diagnostic(diagnostic) if @tests.present?

      test_number
    end
  end

  class Test
    attr_reader :status, :passing, :number, :description, :directive, :diagnostic

    def initialize(status, number, description, directive)
      if (directive =~ /^skip.*/i).present?
        @status = "skipped"
        @directive = /(^skip)(.*)/i.match(directive)&.captures&.last&.strip
      elsif (directive =~ /^todo.*/i).present?
        @status = "ignored"
        @directive = /(^todo)(.*)/i.match(directive)&.captures&.last&.strip
      else
        @status = status
        @directive = directive
      end

      @passing = ["success", "ignored"].include?(@status)

      @number = number
      @description = description

      @diagnostic = ""
    end

    def add_diagnostic(diagnostic)
      return if /\s*?\.\.\./.match?(diagnostic)

      if @diagnostic.empty?
        @diagnostic = diagnostic
      else
        @diagnostic = "#{@diagnostic}\n#{diagnostic}"
      end
    end

    def convert_diagnostic_yaml_to_hash
      leading_spaces = @diagnostic[/\A */].length

      @diagnostic = YAML.safe_load(@diagnostic.split("\n").map { |s| s[leading_spaces..-1] }.join("\n")) || ""
    end
  end
end
