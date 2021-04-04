require 'spec_helper'
require_relative '../../../lib/ruby_terraform/command_line/builder'
require_relative '../../../lib/ruby_terraform/command_line/option/standard'

module RubyTerraform
  module CommandLine
    describe Builder do
      subject(:command_line_builder) { described_class.new(builder_options) }
      let(:builder_options) do
        {
          binary: binary,
          sub_commands: sub_commands,
          options: options,
          arguments: arguments
        }
      end
      let(:binary) { 'terraform' }
      let(:first_command) { 'remote' }
      let(:last_command) { 'config' }
      let(:sub_commands) { [first_command, last_command] }
      let(:arguments) { '/argument/one' }
      let(:options) { %w[-opt1 -opt2] }
      let(:standard) do
        instance_double(RubyTerraform::CommandLine::Option::Standard)
      end
      let(:built_command) { "#{binary} #{sub_commands} #{arguments}" }
      let(:lino_builder) { instance_double(Lino::CommandLineBuilder) }
      let(:lino_subcommand_builder) { instance_double(Lino::SubcommandBuilder) }

      before do
        allow(Lino::CommandLineBuilder).to receive(:for_command).and_return(lino_builder)
        allow(lino_builder).to receive(:with_option_separator).and_return(lino_builder)
        allow(lino_builder).to receive(:with_subcommand).with(first_command).and_return(lino_builder)
        allow(lino_builder).to receive(:with_subcommand).with(last_command)
                                                        .and_return(lino_builder)
                                                        .and_yield(lino_subcommand_builder)
        allow(lino_builder).to receive(:with_arguments).and_return(lino_builder)
        allow(lino_builder).to receive(:build).and_return(built_command)
        allow(options).to receive(:inject).and_yield(lino_subcommand_builder,
                                                     standard)
        allow(standard).to receive(:add_to_subcommand).and_return(lino_subcommand_builder)
      end

      shared_examples 'it ensures the instance variable is an array' do |instance_var|
        before { command_line_builder }

        context 'when the supplied parameter is an array' do
          let(:param) { %w[test value] }

          it 'assigns the value to the instance variable' do
            expect(command_line_builder.instance_variable_get(instance_var)).to eq(param)
          end
        end

        context 'when the supplied parameter is a string' do
          let(:param) { 'test' }

          it 'converts the value to an array and assigns it to the instance variable' do
            expect(command_line_builder.instance_variable_get(instance_var)).to eq([param])
          end
        end

        context 'when the supplied command is nil' do
          let(:param) { nil }

          it 'assigns an empty array to the instance variable' do
            expect(command_line_builder.instance_variable_get(instance_var)).to eq([])
          end
        end
      end

      describe '.new' do
        describe 'configuring lino' do
          before { command_line_builder }

          it 'creates a lino command line builder for the supplied binary' do
            expect(Lino::CommandLineBuilder).to have_received(:for_command).with(binary)
          end

          it 'sets the lino command line builder option separator to be =' do
            expect(lino_builder).to have_received(:with_option_separator).with('=')
          end
        end

        context 'when the parsing the sub_commands' do
          let(:builder_options) do
            { binary: binary, sub_commands: param,
              options: options, arguments: arguments }
          end

          it_behaves_like 'it ensures the instance variable is an array', :@sub_commands
        end

        context 'when the parsing the options' do
          let(:builder_options) do
            { binary: binary, sub_commands: sub_commands,
              options: param, arguments: arguments }
          end

          it_behaves_like 'it ensures the instance variable is an array', :@options
        end

        context 'when the parsing the arguments' do
          let(:builder_options) do
            { binary: binary, sub_commands: sub_commands,
              options: options, arguments: param }
          end

          it_behaves_like 'it ensures the instance variable is an array', :@arguments
        end
      end

      describe '#build' do
        before { command_line_builder.build }

        it 'adds a Lino sub command for each command line command' do
          expect(lino_builder).to have_received(:with_subcommand).with(sub_commands.first)
        end

        it 'associates Lino options with the last command line command' do
          expect(lino_builder).to have_received(:with_subcommand).with(sub_commands.last)
        end

        it 'adds a Lino option/flag to the sub command for each command line option' do
          expect(standard).to have_received(:add_to_subcommand).with(lino_subcommand_builder)
        end

        it 'adds a Lino argument to the sub command for each command line argument' do
          expect(lino_builder).to have_received(:with_arguments).with([arguments])
        end

        it 'requests the Lino CommandLineBuilder build the command line  ' do
          expect(lino_builder).to have_received(:build)
        end

        it 'returns the built command' do
          expect(command_line_builder.build).to eq(built_command)
        end
      end
    end
  end
end
