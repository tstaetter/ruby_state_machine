# frozen_string_literal: true

require_relative "lib/state_machine/version"

Gem::Specification.new do |spec|
  spec.name = "state_machine"
  spec.version = StateMachine::VERSION
  spec.authors = ["tstaetter"]
  spec.email = ["thomas.staetter@gmail.com"]

  spec.summary = "Write a short summary, because RubyGems requires one." # TODO
  spec.description = "Write a longer description or delete this line." # TODO
  spec.homepage = "https://github.com/tstaetter/state_machine"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "nanites", git: "https://github.com/tstaetter/nanites", branch: "1.0.0-rc"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
