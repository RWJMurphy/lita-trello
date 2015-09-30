Gem::Specification.new do |spec|
  spec.name          = "lita-trello"
  spec.version       = "0.0.5"
  spec.authors       = ["Reed Kraft-Murphy"]
  spec.email         = ["reed@reedmurphy.net"]
  spec.description   = "Manage your Trello board from Lita"
  spec.summary       = "Manage your Trello board from Lita"
  spec.homepage      = "https://github.com/RWJMurphy/lita-trello"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.1.0"

  spec.add_runtime_dependency "lita", ">= 4.3"
  spec.add_runtime_dependency "ruby-trello", "~> 1.1"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency 'rubocop'
end
