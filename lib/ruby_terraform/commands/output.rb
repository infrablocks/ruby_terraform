# frozen_string_literal: true

require 'stringio'
require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform output+ command which reads an output variable from a
    # Terraform state file and prints the value. With no additional arguments,
    # output will display all the outputs for the root module. If +:name+ is not
    # specified, all outputs are printed.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Output} via {#execute}, the following
    # options are supported:
    #
    # * +:name+: The name of the output to read.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:state+: the path to the state file to read; defaults to
    #   +"terraform.tfstate"+.
    # * +:no_color+: whether or not the output from the command should be in
    #   color; defaults to +false+.
    # * +:json+: If +true+, machine readable output will be printed in JSON
    #   format; defaults to +false+.
    # * +:raw+: If +true+, for value types that can be automatically converted
    #   to a string, will print the raw string directly, rather than a
    #   human-oriented representation of the value.
    #
    # The {#execute} method accepts an optional second parameter which is a map
    # of invocation options. Currently, the only supported option is
    # +:environment+ which is a map of environment variables to expose during
    # invocation of the command.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Output.new.execute(
    #     name: 'vpc_id')
    #
    class Output < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def invocation_option_defaults(invocation_options)
        super.merge(capture: [:stdout])
      end

      # @!visibility private
      def subcommands
        %w[output]
      end

      # @!visibility private
      def options
        %w[
          -json
          -raw
          -no-color
          -state
        ] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:name]]
      end

      # @!visibility private
      def process_result(result, parameters, _invocation_options)
        parameters[:name] ? result[:output].chomp : result[:output]
      end
    end
  end
end
