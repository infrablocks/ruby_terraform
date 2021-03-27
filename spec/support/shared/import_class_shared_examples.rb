shared_examples 'an import command with an option' do |opt_key|
  switch = "-#{opt_key.to_s.sub('_', '-')}"
  common_options = {
    directory: Faker::File.dir,
    address: Faker::Lorem.word,
    id: Faker::Lorem.word
  }.freeze

  it_behaves_like 'a valid command line', {
    reason: "adds a #{switch} option if a #{opt_key} is provided",
    expected_command: "terraform import -config=#{common_options[:directory]} #{switch}=option-value #{common_options[:address]} #{common_options[:id]}",
    options: common_options.merge({ opt_key => 'option-value' })
  }

  it_behaves_like 'a valid command line', {
    reason: "does not add a #{switch} option if a #{opt_key} is not provided",
    expected_command: "terraform import -config=#{common_options[:directory]} #{common_options[:address]} #{common_options[:id]}",
    options: common_options
  }
end

shared_examples 'an import command with a flag' do |opt_key|
  switch = "-#{opt_key.to_s.sub('_', '-')}"
  common_options = {
    directory: Faker::File.dir,
    address: Faker::Lorem.word,
    id: Faker::Lorem.word
  }.freeze

  it_behaves_like 'a valid command line', {
    reason: "includes the #{switch} flag when the #{opt_key} option is true",
    expected_command: "terraform import -config=#{common_options[:directory]} #{switch} #{common_options[:address]} #{common_options[:id]}",
    options: common_options.merge({ opt_key => true })
  }

  it_behaves_like 'a valid command line', {
    reason: "does not include the #{switch} flag when the #{opt_key} option is false",
    expected_command: "terraform import -config=#{common_options[:directory]} #{common_options[:address]} #{common_options[:id]}",
    options: common_options.merge({ opt_key => false })
  }
end

shared_examples 'an import command with a boolean option' do |opt_key|
  switch = "-#{opt_key.to_s.sub('_', '-')}"
  common_options = {
    directory: Faker::File.dir,
    address: Faker::Lorem.word,
    id: Faker::Lorem.word
  }.freeze

  it_behaves_like 'a valid command line', {
    reason: "includes #{switch}=true when the #{opt_key} option is true",
    expected_command: "terraform import -config=#{common_options[:directory]} #{switch}=true #{common_options[:address]} #{common_options[:id]}",
    options: common_options.merge({ opt_key => true })
  }

  it_behaves_like 'a valid command line', {
    reason: "does not include #{switch}=false when the #{opt_key} option is false",
    expected_command: "terraform import -config=#{common_options[:directory]} #{common_options[:address]} #{common_options[:id]}",
    options: common_options.merge({ opt_key => false })
  }
end
