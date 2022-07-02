# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  enable_coverage :branch
  minimum_coverage line: 100, branch: 100
  add_filter '/spec/'
end

require 'bundler/setup'
require 'faker'
require 'ruby_terraform'

O = RubyTerraform::Options
M = RubyTerraform::Models
V = M::Values

Dir[File.join(__dir__, 'support', '**', '*.rb')]
  .sort
  .each { |f| require f }

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
