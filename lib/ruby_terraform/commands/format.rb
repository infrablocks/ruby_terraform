# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    # Wraps the +terraform fmt+ command which rewrites all terraform
    # configuration files to a canonical format.
    #
    # Both configuration files (.tf) and variables files (.tfvars) are updated.
    # JSON files (.tf.json or .tfvars.json) are not modified.
    #
    # If +:directory+ is not specified in the parameters map then the current
    # working directory will be used. If +:directory+ is +"-"+ then content will
    # be read from the standard input. The given content must be in the
    # terraform language native syntax; JSON is not supported.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Format} via {#execute}, the following
    # options are supported:
    #
    # * +:directory+: the directory containing terraform configuration.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:list+: If +true+, lists files whose formatting differs; defaults to
    #   +false+; always disabled if using standard input.
    # * +:write+: If +true+, writes to source files; defaults to +false+; always
    #   disabled if using standard input or +:check+ is +true+.
    # * +:diff+: If +true+, displays diffs of formatting changes; defaults to
    #   +false+.
    # * +:check+: If +true+, checks if the input is formatted; if any input is
    #   not properly formatted, an {RubyTerraform::Errors::ExecutionError} will
    #   be thrown; defaults to +false+.
    # * +:recursive+: If +true+, also processes files in subdirectories;
    #   defaults to +false+ such that only the provided +:directory+ is
    #   processed.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Format.new.execute(
    #     directory: 'infra/networking')
    class Format < Base
      include RubyTerraform::Options::Common

      # @!visibility private
      def subcommands
        %w[fmt]
      end

      # @!visibility private
      # @todo Add no_color option.
      def options
        %w[
          -list
          -write
          -diff
          -check
          -recursive
        ] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:directory]]
      end
    end
  end
end
