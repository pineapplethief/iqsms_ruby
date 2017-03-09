# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iqsms/version'

Gem::Specification.new do |spec|
  spec.name          = 'iqsms'
  spec.version       = IqSMS::VERSION
  spec.authors       = ['Aleksey Glukhov']
  spec.email         = ['gluhov1985@gmail.com']

  spec.summary       = 'Ruby gem for iqsms JSON API'
  spec.description   = 'Ruby gem for iqsms JSON API'
  spec.homepage      = 'https://github.com/pineapplethief'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.2.0'

  spec.add_runtime_dependency 'addressable', '~> 2.3'
  spec.add_runtime_dependency 'activesupport', '>= 4.2'
  spec.add_runtime_dependency 'connection_pool', '~> 2.2'
  spec.add_runtime_dependency 'http', '~> 2.2'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
end
