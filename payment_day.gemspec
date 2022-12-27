# frozen_string_literal: true

require_relative "lib/payment_day/version"

Gem::Specification.new do |spec|
  spec.name = "payment_day"
  spec.version = PaymentDay::VERSION
  spec.authors = ["PuLLi"]
  spec.email = ["the@pulli.dev"]

  spec.summary = "Calculates the last working day of a month, which is usually pay day."
  spec.description = "Prints out a nicely formatted table of pay days for the given year(s) with the CLI command. Or returns the pay days as an array of arrays sorted by their input."
  spec.homepage = "https://github.com/the-pulli/payment_day"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/the-pulli/payment_day"
  spec.metadata["changelog_uri"] = "https://github.com/the-pulli/payment_day/main/blob/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "rainbow", "~> 3.1"
  spec.add_dependency "terminal-table", "~> 3.0"
  spec.add_dependency "thor", "~> 1.2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
