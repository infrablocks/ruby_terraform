require 'spec_helper'
require_relative '../../../lib/ruby_terraform/command_line/builder'
require_relative '../../../lib/ruby_terraform/command_line/options'

describe RubyTerraform::CommandLine::Builder do
  subject(:command_line_builder) do
    described_class.new(
      binary: binary,
      command_line_commands: command_line_commands,
      command_line_options: command_line_options,
      command_line_arguments: command_line_arguments
    )
  end

  let(:binary) { 'terraform' }
  let(:first_command) { 'remote' }
  let(:last_command) { 'config' }
  let(:command_line_commands) { [first_command, last_command] }
  let(:command_line_arguments) { '/argument/one' }
  let(:command_line_options) { instance_double(RubyTerraform::CommandLine::Options, each: nil) }
  let(:command_line_option) { instance_double(RubyTerraform::CommandLine::Option) }
  let(:built_command) { "#{binary} #{command_line_commands} #{command_line_arguments}" }
  let(:lino_builder) { instance_double(Lino::CommandLineBuilder) }
  let(:lino_subcommand_builder) { instance_double(Lino::SubcommandBuilder) }

  before do
    allow(Lino::CommandLineBuilder).to receive(:for_command).and_return(lino_builder)
    allow(lino_builder).to receive(:with_option_separator).and_return(lino_builder)
    allow(lino_builder).to receive(:with_subcommand).with(first_command).and_return(lino_builder)
    allow(lino_builder).to receive(:with_subcommand).with(last_command).and_return(lino_builder).and_yield(lino_subcommand_builder)
    allow(lino_builder).to receive(:with_argument).and_return(lino_builder)
    allow(lino_builder).to receive(:build).and_return(built_command)
    allow(command_line_options).to receive(:inject).and_yield(lino_subcommand_builder, command_line_option)
    allow(command_line_option).to receive(:add_to_subcommand).and_return(lino_subcommand_builder)
    command_line_builder
  end

  describe '.new' do
    it 'creates a lino command line builder for the supplied binary' do
      expect(Lino::CommandLineBuilder).to have_received(:for_command).with(binary)
    end

    it 'sets the lino command line builder option separator to be =' do
      expect(lino_builder).to have_received(:with_option_separator).with('=')
    end

    context 'when the supplied command_line_commands is a single command' do
      let(:command_line_commands) { 'test' }

      it 'converts the command to an array' do
        expect(command_line_builder.instance_variable_get(:@command_line_commands)).to eq([command_line_commands])
      end
    end

    context 'when the supplied command_line_arguments is a single argument' do
      let(:command_line_arguments) { 'test' }

      it 'converts the argument to an array' do
        expect(command_line_builder.instance_variable_get(:@command_line_arguments)).to eq([command_line_arguments])
      end
    end
  end

  describe '#build' do
    before { command_line_builder.build }

    it 'adds a Lino sub command for each command line command' do
      expect(lino_builder).to have_received(:with_subcommand).with(command_line_commands.first)
    end

    it 'associates Lino options with the last command line command' do
      expect(lino_builder).to have_received(:with_subcommand).with(command_line_commands.last)
    end

    it 'adds a Lino option/flag to the sub command for each command line option' do
      expect(command_line_option).to have_received(:add_to_subcommand).with(lino_subcommand_builder)
    end

    it 'adds a Lino argument to the sub command for each command line argument' do
      expect(lino_builder).to have_received(:with_argument).with(command_line_arguments)
    end

    context 'when the argument value is nil' do
      let(:command_line_arguments) { nil }

      it 'does not add the Lino argument to the sub command' do
        expect(lino_builder).not_to have_received(:with_argument).with(command_line_arguments)
      end
    end

    it 'requests the Lino CommandLineBuilder build the command line  ' do
      expect(lino_builder).to have_received(:build)
    end

    it 'returns the built command' do
      expect(command_line_builder.build).to eq(built_command)
    end
  end
end
