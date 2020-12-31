require_relative 'lib/simply_give/version'

Gem::Specification.new do |spec|
  spec.name          = "simply_give"
  spec.version       = SimplyGive::VERSION
  spec.authors       = ["Eric"]
  spec.email         = ["eric.m.lombardo@gmail.com"]

  spec.summary       = %q{"Help people donate to causes they believe in"}
  spec.description   = %q{"Help people donate to causes they believe in"}
  spec.homepage      = "https://github.com/ericlombardo/simply_give"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = "https://github.com/ericlombardo/simply_give"
  spec.metadata["source_code_uri"] = "https://github.com/ericlombardo/simply_give"
  spec.metadata["changelog_uri"] = "https://github.com/ericlombardo/simply_give"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
