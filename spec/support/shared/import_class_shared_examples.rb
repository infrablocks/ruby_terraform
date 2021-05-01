# frozen_string_literal: true

require_relative './global_options'

shared_examples(
  'an import command with an option'
) do |command_klass, opt_key|
  switch = "-#{opt_key.to_s.gsub('_', '-')}"
  common =
    {
      directory: Faker::File.dir,
      address: Faker::Lorem.word,
      id: Faker::Lorem.word
    }.freeze

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason:
      "adds a #{switch} option if a #{opt_key} is provided",
    expected:
      "terraform import -config=#{common[:directory]} " \
          "#{switch}=option-value #{common[:address]} #{common[:id]}",
    binary: 'terraform',
    parameters: common.merge({ opt_key => 'option-value' })
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason:
      "does not add a #{switch} option if a #{opt_key} is not provided",
    expected:
      "terraform import -config=#{common[:directory]} " \
          "#{common[:address]} #{common[:id]}",
    binary: 'terraform',
    parameters: common
  )
end

shared_examples(
  'an import command with a global option'
) do |command_klass, opt_key|
  switch = "-#{opt_key.to_s.gsub('_', '-')}"
  common =
    {
      directory: Faker::File.dir,
      address: Faker::Lorem.word,
      id: Faker::Lorem.word
    }.freeze

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason:
      "adds a #{switch} option if a #{opt_key} is provided",
    expected:
      "terraform #{switch}=option-value import " \
          "-config=#{common[:directory]} #{common[:address]} #{common[:id]}",
    binary: 'terraform',
    parameters: common.merge({ opt_key => 'option-value' })
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason:
      "does not add a #{switch} option if a #{opt_key} is not provided",
    expected:
      "terraform import -config=#{common[:directory]} " \
          "#{common[:address]} #{common[:id]}",
    binary: 'terraform',
    parameters: common
  )
end

shared_examples(
  'an import command with a flag'
) do |command_klass, opt_key|
  switch = "-#{opt_key.to_s.gsub('_', '-')}"
  common =
    {
      directory: Faker::File.dir,
      address: Faker::Lorem.word,
      id: Faker::Lorem.word
    }.freeze

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason:
      "includes the #{switch} flag when the #{opt_key} option is true",
    expected:
      "terraform import -config=#{common[:directory]} #{switch} " \
          "#{common[:address]} #{common[:id]}",
    binary: 'terraform',
    parameters: common.merge({ opt_key => true })
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason:
      "does not include the #{switch} flag when the #{opt_key} option " \
          'is false',
    expected:
      "terraform import -config=#{common[:directory]} " \
          "#{common[:address]} #{common[:id]}",
    binary: 'terraform',
    parameters: common.merge({ opt_key => false })
  )
end

shared_examples(
  'an import command with a boolean option'
) do |command_klass, opt_key|
  switch = "-#{opt_key.to_s.gsub('_', '-')}"
  common =
    {
      directory: Faker::File.dir,
      address: Faker::Lorem.word,
      id: Faker::Lorem.word
    }.freeze

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason:
      "includes #{switch}=true when the #{opt_key} option is true",
    expected:
      "terraform import -config=#{common[:directory]} #{switch}=true " \
          "#{common[:address]} #{common[:id]}",
    binary: 'terraform',
    parameters: common.merge({ opt_key => true })
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason:
      "does not include #{switch}=false when the #{opt_key} option is false",
    expected:
      "terraform import -config=#{common[:directory]} #{switch}=false " \
          "#{common[:address]} #{common[:id]}",
    binary: 'terraform',
    parameters: common.merge({ opt_key => false })
  )
end

shared_examples(
  'an import command with common options'
) do |command_klass|
  GlobalOptions.each_key do |opt_key|
    it_behaves_like(
      'an import command with a global option',
      command_klass, opt_key
    )
  end
end
