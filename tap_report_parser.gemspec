
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tap_report_parser/version"

Gem::Specification.new do |spec|
  spec.name          = "tap_report_parser"
  spec.version       = TapReportParser::VERSION
  spec.authors       = ["Abhimanyu Singh"]
  spec.email         = ["abhisinghabhimanyu@gmail.com"]

  spec.summary       = %q{Parse a TAP test report.}
  spec.description   = %q{A TAP test report defines several properties for each tests.
                         The objective of the gem is to provide all the specified properties
                         after parsing the report either from the file or text.}
  spec.homepage      = "https://www.github.com/avmnu-sng/tap_report_parser"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("rails", ">= 4.0")

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.required_ruby_version = '>= 2.4'
end
