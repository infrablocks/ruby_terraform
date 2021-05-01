# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform apply+ command which creates or updates
    # infrastructure according to terraform configuration files in the provided
    # directory.
    #
    # By default, terraform will generate a new plan and present it for approval
    # before taking any action. Alternatively, the command accepts a plan file
    # created by a previous invocation, in which case terraform will take the
    # actions described in that plan without any confirmation prompt.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Apply} via {#execute}, the following
    # options are supported:
    #
    # * +:directory+: the path to a directory containing terraform configuration.
    # * +:plan+: the path to a pre-computed plan to be applied.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:auto_approve+: if +true+, skips interactive approval of the generated
    #   plan before applying; defaults to +false+.
    # * +:backup+: the path to backup the existing state file before modifying;
    #   defaults to the +:state_out+ path with +".backup"+ extension; set
    #   +:no_backup+ to +true+ to skip backups entirely.
    # * +:compact_warnings+: when +true+, if terraform produces any warnings
    #   that are not accompanied by errors, they are shown in a more compact
    #   form that includes only the summary messages; defaults to +false+.
    # * +:input+: when +false+, will not ask for input for variables not
    #   directly set; defaults to +true+.
    # * +:lock+: when +true+, locks the state file when locking is supported;
    #   when +false+, does not lock the state file; defaults to +true+.
    # * +:lock_timeout+: the duration to retry a state lock; defaults to +"0s"+.
    # * +:no_backup+: when +true+, no backup file will be written; defaults to
    #   +false+.
    # * +:no_color+: whether or not the output from the command should be in
    #   color; defaults to +false+.
    # * +:parallelism+: the number of parallel resource operations; defaults to
    #   +10+.
    # * +:refresh+: when +true+, updates state prior to checking for
    #   differences; when +false+ uses locally available state; defaults to
    #   +true+; this has no effect when +:plan+ is provided.
    # * +:state+: the path to the state file from which to read state and in
    #   which to store state (unless +:state_out+ is specified); defaults to
    #   +"terraform.tfstate"+.
    # * +:state_out+: the path to write state to that is different than
    #   +:state+; this can be used to preserve the old state.
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
    #   RubyTerraform::Commands::Apply.new.execute(
    #     directory: 'infra/networking',
    #     vars: {
    #       region: 'eu-central'
    #     })
    #
    class Apply < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[apply]
      end

      # rubocop:disable Metrics/MethodLength

      # @!visibility private
      def options
        %w[
          -backup
          -compact-warnings
          -lock
          -lock-timeout
          -input
          -auto-approve
          -no-color
          -parallelism
          -refresh
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
        [parameters[:plan] || parameters[:directory]]
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
