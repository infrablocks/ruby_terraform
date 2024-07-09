# frozen_string_literal: true

require 'lino'
require 'tempfile'

require_relative '../errors'

module RubyTerraform
  module Commands
    class Base
      # rubocop:disable Metrics/AbcSize

      # Constructs an instance of the command.
      #
      def initialize(opts = {})
        @binary = opts[:binary] || RubyTerraform.configuration.binary
        @logger = opts[:logger] || RubyTerraform.configuration.logger
        @options = opts[:options] || RubyTerraform.configuration.options
        @stdin = opts[:stdin] || RubyTerraform.configuration.stdin
        @stdout = opts[:stdout] || RubyTerraform.configuration.stdout
        @stderr = opts[:stderr] || RubyTerraform.configuration.stderr
      end

      # rubocop:enable Metrics/AbcSize

      # Executes the command instance.
      #
      # @param [Hash<String, Object>] parameters The parameters used to
      #   invoke the command. See subclass documentation for details of
      #   supported options.
      # @param [Hash<String, Object>] invocation_options Additional options
      #   controlling the invocation of the command.
      # @option invocation_options [Hash<String, String>] :environment A map
      #   of environment variables to expose at command invocation time.
      def execute(parameters = {}, invocation_options = {})
        parameters = resolve_parameters(parameters)
        invocation_options = resolve_invocation_options(invocation_options)

        do_before(parameters)
        result = build_and_execute_command(parameters, invocation_options)
        do_after(parameters)

        prepare_result(result, parameters, invocation_options)
      rescue Lino::Errors::ExecutionError
        message = "Failed while running '#{command_name}'."
        logger.error(message)
        raise Errors::ExecutionError, message
      end

      private

      attr_reader :binary, :logger, :stdin, :stdout, :stderr

      def command_name
        self.class.to_s.split('::')[-1].downcase
      end

      def do_before(_parameters); end

      def do_after(_parameters); end

      def build_command(parameters, invocation_options)
        Lino::CommandLineBuilder
          .for_command(@binary)
          .with_environment_variables(invocation_options[:environment] || {})
          .with_options_after_subcommands
          .with_option_separator('=')
          .with_appliables(@options.resolve(options, parameters))
          .with_subcommands(subcommands)
          .with_arguments(arguments(parameters).compact.flatten)
          .build
      end

      def process_result(result, _parameters, _invocation_options)
        result
      end

      def parameter_defaults(_parameters)
        {}
      end

      def parameter_overrides(_parameters)
        {}
      end

      def invocation_option_defaults(_invocation_options)
        { capture: [], result: :processed }
      end

      def subcommands
        []
      end

      def options
        []
      end

      def arguments(_parameters)
        []
      end

      def build_and_execute_command(parameters, invocation_options)
        command = build_command(parameters, invocation_options)
        stdout = resolve_stdout(invocation_options)
        stderr = resolve_stderr(invocation_options)

        logger.debug("Running '#{command}'.")
        command.execute(stdin:, stdout:, stderr:)

        process_streams(invocation_options, stdout, stderr)
      end

      def resolve_parameters(parameters)
        parameter_defaults(parameters)
          .merge(parameters)
          .merge(parameter_overrides(parameters))
      end

      def resolve_invocation_options(invocation_options)
        invocation_option_defaults(invocation_options)
          .merge(invocation_options)
      end

      def resolve_stdout(invocation_options)
        invocation_options[:capture].include?(:stdout) ? Tempfile.new : @stdout
      end

      def resolve_stderr(invocation_options)
        invocation_options[:capture].include?(:stderr) ? Tempfile.new : @stderr
      end

      def process_streams(invocation_options, stdout, stderr)
        cap = invocation_options[:capture]

        return nil if cap == []

        result = {}
        result = add_contents_to_result(cap, result, :stdout, stdout, :output)
        add_contents_to_result(cap, result, :stderr, stderr, :error)
      end

      def add_contents_to_result(capture, result, stream_name, stream, type)
        return result unless capture.include?(stream_name)

        stream.rewind
        result.merge({ type => stream.read })
      end

      def prepare_result(result, parameters, invocation_options)
        return result if invocation_options[:result] == :raw

        process_result(result, parameters, invocation_options)
      end
    end
  end
end
