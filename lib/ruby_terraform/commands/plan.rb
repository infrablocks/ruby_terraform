# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform plan+ command which generates a speculative execution
    # plan, showing what actions Terraform would take to apply the current
    # configuration. This command will not actually perform the planned actions.
    #
    # You can optionally save the plan to a file, which you can then pass to
    # the {Apply} command to perform exactly the actions described in the plan.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Plan} via {#execute}, the following
    # options are supported:
    #
    # * +:directory+: the path to a directory containing terraform
    #   configuration (deprecated in terraform 0.14, removed in terraform 0.15,
    #   use +:chdir+ instead).
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:compact_warnings+: when +true+, if terraform produces any warnings
    #   that are not accompanied by errors, they are shown in a more compact
    #   form that includes only the summary messages; defaults to +false+.
    # * +:destroy+: when +true+, a plan will be generated to destroy all
    #   resources managed by the given configuration and state; defaults to
    #   +false+.
    # * +:detailed_exitcode+: whether or not to return detailed exit codes when
    #   the command exits; this will change the meaning of exit codes to:
    #   0 - Succeeded, diff is empty (no changes); 1 - Errored; 2 - Succeeded,
    #   there is a diff; defaults to +false+.
    # * +:input+: when +false+, will not ask for input for variables not
    #   directly set; defaults to +true+.
    # * +:lock+: when +true+, locks the state file when locking is supported;
    #   when +false+, does not lock the state file; defaults to +true+.
    # * +:lock_timeout+: the duration to retry a state lock; defaults to +"0s"+.
    # * +:no_color+: whether or not the output from the command should be in
    #   color; defaults to +false+.
    # * +:parallelism+: the number of parallel resource operations; defaults to
    #   +10+.
    # * +:plan+: the path to output the plan if it should be saved to a file.
    # * +:refresh+: when +true+, updates state prior to checking for
    #   differences; when +false+ uses locally available state; defaults to
    #   +true+; this has no effect when +:plan+ is provided.
    # * +replace+: force replacement of a particular resource instance using
    #   its resource address. If the plan would've normally produced an update
    #   or no-op action for this instance, Terraform will plan to replace it
    #   instead.
    # * +replaces+: an array of resource addresses to replace; if both
    #   +replace+ and +replaces+ are provided, all resources will be replaced.
    # * +:state+: the path to the state file from which to read state and in
    #   which to store state (unless +:state_out+ is specified); defaults to
    #   +"terraform.tfstate"+.
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
    #   RubyTerraform::Commands::Plan.new.execute(
    #     directory: 'infra/networking',
    #     vars: {
    #       region: 'eu-central'
    #     })
    #
    class Plan < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[plan]
      end

      # rubocop:disable Metrics/MethodLength

      # @!visibility private
      def options
        %w[
          -compact-warnings
          -destroy
          -detailed-exitcode
          -input
          -lock
          -lock-timeout
          -no-color
          -out
          -parallelism
          -refresh
          -replace
          -state
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
        { vars: {}, var_files: [], targets: [], replaces: [] }
      end
    end
  end
end
