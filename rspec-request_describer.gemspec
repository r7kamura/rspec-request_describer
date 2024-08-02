lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/request_describer/version'

Gem::Specification.new do |spec|
  spec.name          = 'rspec-request_describer'
  spec.version       = RSpec::RequestDescriber::VERSION
  spec.authors       = ['Ryo Nakamura']
  spec.email         = ['r7kamura@gmail.com']
  spec.summary       = 'An RSpec plugin to write self-documenting request-specs.'
  spec.homepage      = 'https://github.com/r7kamura/rspec-request_describer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").grep_v(%r{^spec/})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
end
