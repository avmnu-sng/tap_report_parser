# TapReportParser

This gem parses a TAP report per the specifications listed on https://testanything.org/tap-specification.html. Each of the tests has six attributes: `number`, `description`, `status`, `directive`, `diagnostic` and `passing`.

- The `number` is test number. If the `number` is not present, the parser maintains its own count.
- The `description` is the text describing the test. If the `description` is not present, then its value is empty string.
- The `status` is represented by one of the four values: `success` (when test is passing), `failure` (when test is failing), `skipped` (when test is marked as skipped irrespective of success or failure), and `ignore` (when test is marked as todo irrespective of success or failure).
- The `directive` is either skipped or todo.
- The `diagnostic` is a YAML block or text. If it is YAML then its value is ruby Hash, otherwise string. If the `diagnostic` is not present, then its value is empty string.
- The value of the `passing` is `true` if test status is either `passing` or `ignored`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tap_report_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tap_report_parser

## Usage

You can parse report either from file or text, i.e.,
```ruby
report = TapReportParser::Report.from_text(text)
report = TapReportParser::Report.from_file(file)
```

For example, consider the following TAP report:
```tap
TAP version 13
1..6
#
# Create a new Board and Tile, then place
# the Tile onto the board.
#
ok 1 - The object is a Board
ok 2 - Board size is zero
ok 3 - The object is a Tile
ok 4 - Get possible places to put the Tile
ok 5 - Placing the tile produces no error
ok 6 - Board size is 1
```

Parsing the report from text will return the `TapReportParser::Report` object, which has the following three attributes:

- `test_count`: The test count
- `tests`: Array of `TapReportParser::Test` objects each describing the test. Each of the test object has six attributes: `number`, `description`, `status`, `directive`, `diagnostic` and `passing`.
- `passing`: A boolean value which is `true` if all the tests are passing, i.e., the status is either `success` or `ignored`, otherwise `false`.

```ruby
# Tests count
report.test_count
 => 6
# All the tests passing?
report.passing
 => true
# Tests
 => [#<TapReportParser::Test:0x00007f943a97d968 @status="success", @directive="", @passing=true, @number=1, @description="The object is a Board", @diagnostic="">, #<TapReportParser::Test:0x00007f943a97d580 @status="success", @directive="", @passing=true, @number=2, @description="Board size is zero", @diagnostic="">, #<TapReportParser::Test:0x00007f943a97d198 @status="success", @directive="", @passing=true, @number=3, @description="The object is a Tile", @diagnostic="">, #<TapReportParser::Test:0x00007f943a97cd88 @status="success", @directive="", @passing=true, @number=4, @description="Get possible places to put the Tile", @diagnostic="">, #<TapReportParser::Test:0x00007f943a97c978 @status="success", @directive="", @passing=true, @number=5, @description="Placing the tile produces no error", @diagnostic="">, #<TapReportParser::Test:0x00007f943a97c590 @status="success", @directive="", @passing=true, @number=6, @description="Board size is 1", @diagnostic="">]
# Test number
report.tests.first.number
 => 1
# Test description
report.tests.first.description
 => "The object is a Board"
# Test status
report.tests.first.status
 => "success"
# Test passing?
report.tests.first.passing
 => true
# Test directive
report.tests.first.directive
 => ""
# Test diagnostic
report.tests.first.diagnostic
 => ""
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/avmnu-sng/tap_report_parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TapReportParser project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/tap_report_parser/blob/master/CODE_OF_CONDUCT.md).
