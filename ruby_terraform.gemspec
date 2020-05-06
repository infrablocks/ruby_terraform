# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_terraform/version'
require 'date'

Gem::Specification.new do |spec|
  spec.name = 'ruby-terraform'
  spec.version = RubyTerraform::VERSION
  spec.authors = ['Toby Clemson']
  spec.email = ['tobyclemson@gmail.com']

  spec.date = Date.today.to_s
  spec.summary = 'A simple Ruby wrapper for invoking Terraform commands.'
  spec.description = 'Wraps the Terraform CLI so that Terraform can be invoked from a Ruby script or Rakefile.'
  spec.homepage = 'https://github.com/infrablocks/ruby_terraform'
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) {|f| File.basename(f)}
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'lino', '>= 1.1', "< 2"

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rake_circle_ci', '~> 0.3'
  spec.add_development_dependency 'rake_github', '~> 0.3'
  spec.add_development_dependency 'rake_ssh', '~> 0.2'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'gem-release', '~> 2.1'
end
