# frozen_string_literal: true

require_relative "lib/golem/version"

Gem::Specification.new do |spec|
  spec.name = "golem-ai"
  spec.version = Golem::VERSION
  spec.authors = ["Kasper König"]
  spec.email = ["gh@kasper.codes"]

  spec.summary = "Interact with Open AI"
  spec.homepage = "https://github.com/kholbekj/golem"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "ruby-openai"
  spec.add_dependency "dotenv"
  spec.add_dependency "httparty"
  spec.add_dependency "pry"
  spec.add_dependency "nokogiri"
  spec.add_dependency "tiktoken_ruby", "~> 0.0.3"


  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
