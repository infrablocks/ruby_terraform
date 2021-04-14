# frozen_string_literal: true

require 'spec_helper'
require_relative '../../support/shared/common_options'

describe RubyTerraform::Commands::ProvidersSchema do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  command = 'providers schema'

  context 'when no binary is supplied' do
    let(:command) { described_class.new }

    it_behaves_like 'a valid command line', {
      reason: 'defaults to the configured binary when none provided',
      expected_command: "path/to/binary #{command} -json",
      options: {}
    }
  end

  it_behaves_like 'a valid command line', {
    reason: 'includes the mandatory -json flag when the option is true',
    expected_command: "terraform #{command} -json",
    options: { json: true }
  }

  it_behaves_like 'a valid command line', {
    reason: 'includes the mandatory -json flag when the option is not set',
    expected_command: "terraform #{command} -json",
    options: {}
  }

  it_behaves_like 'a valid command line', {
    reason: 'includes the mandatory -json flag when the option is set to false',
    expected_command: "terraform #{command} -json",
    options: { json: false }
  }

  CommonOptions.each_key do |opt_key|
    switch = "-#{opt_key.to_s.gsub('_', '-')}"
    switch_value = 'option-value'

    it_behaves_like 'a valid command line', {
      reason: "adds a #{switch} option if a #{opt_key} is provided",
      expected_command: "terraform #{command} -json #{switch}=#{switch_value}",
      options: { opt_key => switch_value }
    }

    it_behaves_like 'a valid command line', {
      reason: "does not add a #{switch} option if a #{opt_key} is not provided",
      expected_command: "terraform #{command} -json",
      options: {}
    }
  end
end
