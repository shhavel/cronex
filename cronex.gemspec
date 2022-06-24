# frozen_string_literal: true

require_relative "lib/cronex/version"

Gem::Specification.new do |spec|
  spec.name = "cronex"
  spec.version = Cronex::VERSION
  spec.authors = ["Oleksandr Avoiants"]
  spec.email = ["shhavel@gmail.com"]

  spec.summary = "CLI to parse a cron string and expands each field to show the times at which it will run."
  spec.description = "CLI to parse a cron string and expands each field to show the times at which it will run."
  spec.homepage = "https://github.com/shhavel/cronex"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/shhavel/cronex"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

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
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_development_dependency "aruba", "~> 0.14.2"
  spec.add_development_dependency "pry"
end
