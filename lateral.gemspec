# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lateral/version'

Gem::Specification.new do |spec|
  spec.name    = 'lateral'
  spec.version = Lateral::VERSION
  spec.authors = ['Navin Peiris']
  spec.email   = ['navin.peiris@gmail.com']

  spec.summary     = %q{Ruby wrapper for lateral.io content recommendation API}
  spec.description = %q{Ruby wrapper for lateral.io content recommendation API}
  spec.homepage    = 'https://github.com/navinpeiris/lateral'
  spec.license     = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '>= 0.14.0'
  spec.add_dependency 'gem_config', '~> 0.3.1'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.5.0'
  spec.add_development_dependency 'rspec-its', '~> 1.2.0'
  spec.add_development_dependency 'rubocop', '~> 0.47.0'
  spec.add_development_dependency 'webmock', '~> 2.3.2'
  spec.add_development_dependency 'simplecov', '~> 0.12.0'
  spec.add_development_dependency 'guard-bundler', '~> 2.1.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7.3'
  spec.add_development_dependency 'guard-rubocop', '~> 1.2.0'
  spec.add_development_dependency 'terminal-notifier-guard', '~> 1.7.0'
  spec.add_development_dependency 'terminal-notifier', '~> 1.7.1'
end
