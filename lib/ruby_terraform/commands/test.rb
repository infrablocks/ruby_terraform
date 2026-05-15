# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform test+ command which executes automated integration
    # tests defined in +.tftest.hcl+ files.
    #
    # Terraform discovers test files in the configured test directory (by
    # default +tests+) and in the root module, then runs each +run+ block in
    # turn, reporting on the outcome of the assertions.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Test} via {#execute}, the following
    # options are supported:
    #
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:cloud_run+: if set, executes the tests remotely using the given
    #   Terraform Cloud/Enterprise module source address rather than running
    #   them locally.
    # * +:filter+: restrict which test files are executed; if both +:filter+
    #   and +:filters+ are provided, all filters will be passed to terraform.
    # * +:filters+: an array of test file paths to restrict which test files
    #   are executed; if both +:filter+ and +:filters+ are provided, all
    #   filters will be passed to terraform.
    # * +:json+: whether or not to produce output in a machine-readable JSON
    #   format; defaults to +false+.
    # * +:no_color+: whether or not the output from the command should be in
    #   color; defaults to +false+.
    # * +:test_directory+: the directory containing test files; defaults to
    #   +"tests"+.
    # * +:vars+: a map of variables to be passed to the terraform configuration.
    # * +:var_file+: the path to a terraform var file; if both +:var_file+ and
    #   +:var_files+ are provided, all var files will be passed to terraform.
    # * +:var_files+: an array of paths to terraform var files; if both
    #   +:var_file+ and +:var_files+ are provided, all var files will be passed
    #   to terraform.
    # * +:verbose+: when +true+, print the plan or state for each test run
    #   block as it executes; defaults to +false+.
    #
    # The {#execute} method accepts an optional second parameter which is a map
    # of invocation options. Currently, the only supported option is
    # +:environment+ which is a map of environment variables to expose during
    # invocation of the command.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Test.new.execute(
    #     filters: ['tests/network.tftest.hcl'],
    #     verbose: true)
    #
    class Test < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[test]
      end

      # @!visibility private
      def options
        %w[
          -cloud-run
          -filter
          -json
          -no-color
          -test-directory
          -var
          -var-file
          -verbose
        ] + super
      end

      # @!visibility private
      def parameter_defaults(_parameters)
        { vars: {}, var_files: [], filters: [] }
      end
    end
  end
end
