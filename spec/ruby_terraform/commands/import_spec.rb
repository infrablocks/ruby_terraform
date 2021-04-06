# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Import do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  common =
    {
      directory: Faker::File.dir,
      address: Faker::Lorem.word,
      id: Faker::Lorem.word
    }.freeze

  it_behaves_like(
    'a valid command line',
    {
      reason:
        'calls the terraform import command passing the supplied directory',
      expected_command:
        "terraform import -config=#{common[:directory]} " \
          "#{common[:address]} #{common[:id]}",
      options: common
    }
  )

  context 'when no binary is supplied' do
    let(:command) { described_class.new }

    it_behaves_like(
      'a valid command line',
      {
        reason: 'defaults to the configured binary when none provided',
        expected_command:
          "path/to/binary import -config=#{common[:directory]} " \
            "#{common[:address]} #{common[:id]}",
        options: common
      }
    )
  end

  it_behaves_like(
    'a valid command line',
    {
      reason: 'adds a var option for each supplied var',
      expected_command:
        "terraform import -config=#{common[:directory]} " \
          "-var 'first=1' -var 'second=two' #{common[:address]} #{common[:id]}",
      options: common.merge({ vars: { first: 1, second: 'two' } })
    }
  )

  it_behaves_like(
    'a valid command line',
    {
      reason: 'correctly serialises list/tuple vars',
      expected_command:
        "terraform import -config=#{common[:directory]} " \
          "-var 'list=[1,\"two\",3]' #{common[:address]} #{common[:id]}",
      options: common.merge({ vars: { list: [1, 'two', 3] } })
    }
  )

  it_behaves_like(
    'a valid command line',
    {
      reason: 'correctly serialises map/object vars',
      expected_command:
        "terraform import -config=#{common[:directory]} -var " \
          "'map={\"first\":1,\"second\":\"two\"}' " \
          "#{common[:address]} #{common[:id]}",
      options: common.merge({ vars: { map: { first: 1, second: 'two' } } })
    }
  )

  it_behaves_like(
    'a valid command line',
    {
      reason: 'correctly serialises vars with lists/tuples of maps/objects',
      expected_command:
        "terraform import -config=#{common[:directory]} -var " \
          "'list_of_maps=[{\"key\":\"value\"},{\"key\":\"value\"}]' " \
          "#{common[:address]} #{common[:id]}",
      options: common.merge(
        {
          vars: {
            list_of_maps: [{ key: 'value' }, { key: 'value' }]
          }
        }
      )
    }
  )

  it_behaves_like(
    'an import command with an option',
    :state
  )

  it_behaves_like(
    'an import command with an option',
    :backup
  )

  it_behaves_like(
    'a valid command line',
    {
      reason: 'disables backup if no_backup is true',
      expected_command:
        "terraform import -config=#{common[:directory]} -backup=- " \
          "#{common[:address]} #{common[:id]}",
      options: common.merge(
        {
          backup: 'some/state.tfstate.backup',
          no_backup: true
        }
      )
    }
  )

  it_behaves_like(
    'an import command with a flag',
    :no_color
  )

  it_behaves_like(
    'a valid command line',
    {
      reason: 'adds a var-file option if a var file is provided',
      expected_command:
        "terraform import -config=#{common[:directory]} " \
          "-var-file=some/vars.tfvars #{common[:address]} #{common[:id]}",
      options: common.merge({ var_file: 'some/vars.tfvars' })
    }
  )

  it_behaves_like(
    'a valid command line',
    {
      reason: 'adds a var-file option for each element of var-files array',
      expected_command:
        "terraform import -config=#{common[:directory]} " \
          '-var-file=some/vars1.tfvars -var-file=some/vars2.tfvars ' \
          "#{common[:address]} #{common[:id]}",
      options: common.merge(
        {
          var_files: %w[some/vars1.tfvars some/vars2.tfvars]
        }
      )
    }
  )

  it_behaves_like(
    'a valid command line',
    {
      reason: 'ensures that var_file and var_files options work together',
      expected_command:
        "terraform import -config=#{common[:directory]} " \
          '-var-file=some/vars.tfvars -var-file=some/vars1.tfvars ' \
          "-var-file=some/vars2.tfvars #{common[:address]} #{common[:id]}",
      options: common.merge(
        {
          var_file: 'some/vars.tfvars',
          var_files: %w[some/vars1.tfvars some/vars2.tfvars]
        }
      )
    }
  )

  it_behaves_like(
    'an import command with a boolean option',
    :input
  )
end
