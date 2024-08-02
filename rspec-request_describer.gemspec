# frozen_string_literal: true

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

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
end
