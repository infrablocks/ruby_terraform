# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    # Wraps the +terraform refresh+ command which updates the state file of your
    # infrastructure with metadata that matches the physical resources they are
    # tracking.
    #
    # This will not modify your infrastructure, but it can modify your state
    # file to update metadata. This metadata might cause new changes to occur
    # when you generate a plan or call apply next.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Refresh} via {#execute}, the following
    # options are supported:
    #
    # * +:directory+: the directory containing terraform configuration
    #   (deprecated, removed in Terraform 0.15).
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:backup+: the path to backup the existing state file before modifying;
    #   defaults to the +:state_out+ path with +".backup"+ extension; set
    #   +:no_backup+ to +true+ to skip backups entirely (legacy).
    # * +:compact_warnings+: when +true+, if terraform produces any warnings
    #   that are not accompanied by errors, they are shown in a more compact
    #   form that includes only the summary messages; defaults to +false+.
    # * +:input+: when +false+, will not ask for input for variables not
    #   directly set; defaults to +true+.
    # * +:lock+: when +true+, locks the state file when locking is supported;
    #   when +false+, does not lock the state file; defaults to +true+.
    # * +:lock_timeout+: the duration to retry a state lock; defaults to +"0s"+.
    # * +:no_backup+: when +true+, no backup file will be written; defaults to
    #   +false+ (legacy).
    # * +:no_color+: whether or not the output from the command should be in
    #   color; defaults to +false+.
    # * +:parallelism+: the number of parallel resource operations; defaults to
    #   +10+.
    # * +:state+: the path to the state file from which to read state and in
    #   which to store state (unless +:state_out+ is specified); defaults to
    #   +"terraform.tfstate"+ (legacy).
    # * +:state_out+: the path to write state to that is different than
    #   +:state+; this can be used to preserve the old state (legacy).
    # * +:target+: the address of a resource to target; if both +:target+ and
    #   +:targets+ are provided, all targets will be passed to terraform.
    # * +:targets+: an array of resource addresses to target; if both +:target+
    #   and +:targets+ are provided, all targets will be passed to terraform.
    # * +:vars+: a map of variables to be passed to the terraform configuration.
    # * +:var_file+: the path to a terraform var file; if both +:var_file+ and
    #   +:var_files+ are provided, all var files will be passed to terraform.
    # * +:var_files+: an array of paths to terraform var files; if both
    #   +:var_file+ and +:var_files+ are provided, all var files will be passed
    #   to terraform.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Refresh.new.execute(
    #     directory: 'infra/networking',
    #     vars: {
    #       region: 'eu-central'
    #     })
    #
    class Refresh < Base
      include RubyTerraform::Options::Common

      # @!visibility private
      def subcommands
        %w[refresh]
      end

      # rubocop:disable Metrics/MethodLength

      # @!visibility private
      def options
        %w[
          -backup
          -compact-warnings
          -input
          -lock
          -lock-timeout
          -no-color
          -parallelism
          -state
          -state-out
          -target
          -var
          -var-file
        ] + super
      end

      # rubocop:enable Metrics/MethodLength

      # @!visibility private
      def arguments(parameters)
        [parameters[:directory]]
      end

      # @!visibility private
      def parameter_defaults(_parameters)
        { vars: {}, var_files: [], targets: [] }
      end

      # @!visibility private
      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
