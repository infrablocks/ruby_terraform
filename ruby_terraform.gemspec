# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_terraform/version'

Gem::Specification.new do |spec|
  spec.name = 'ruby_terraform'
  spec.version = RubyTerraform::VERSION
  spec.authors = ['Toby Clemson']
  spec.email = ['tobyclemson@gmail.com']

  spec.date = '2017-02-20'
  spec.summary = 'A simple Ruby wrapper for invoking Terraform commands.'
  spec.description = 'Wraps the Terraform CLI so that Terraform can be invoked from a Ruby script or Rakefile.'
  spec.homepage = 'https://github.com/tobyclemson/ruby_terraform'
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'gem-release', '~> 0.7'
end
