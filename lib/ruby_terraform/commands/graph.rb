# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform graph+ command which outputs the visual execution
    # graph of terraform resources according to either the current configuration
    # or an execution plan.
    #
    # The graph is outputted in DOT format. The typical program that can
    # read this format is GraphViz, but many web services are also available to
    # read this format.
    #
    # The +:type+ option can be used to control the type of graph shown.
    # Terraform creates different graphs for different operations. See the
    # options below for the list of types supported. The default type is
    # +"plan"+ if a configuration is given, and +"apply"+ if a plan file is
    # passed as an argument.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Graph} via {#execute}, the following
    # options are supported:
    #
    # * +:directory+: the path to a directory containing terraform
    #   configuration (deprecated in terraform 0.14, removed in terraform 0.15,
    #   use +:chdir+ instead).
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:plan+: render the graph using the specified plan file instead of the
    #   configuration in the current directory.
    # * +:draw_cycles+: if +true+, highlights any cycles in the graph with
    #   colored edges; this helps when diagnosing cycle errors; defaults to
    #   +false+.
    # * +:type+: the type of graph to output; can be: +"plan"+,
    #   +"plan-destroy"+, +"apply"+, +"validate"+, +"input"+, +"refresh"+;
    #   defaults to +"apply"+ if +:plan+ is provided, +"plan"+ otherwise.
    # * +:module_depth+: (deprecated) in prior versions of terraform, specified
    #   the depth of modules to show in the output.
    #
    # The {#execute} method accepts an optional second parameter which is a map
    # of invocation options. Currently, the only supported option is
    # +:environment+ which is a map of environment variables to expose during
    # invocation of the command.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Graph.new.execute
    #
    class Graph < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[graph]
      end

      # @!visibility private
      def options
        %w[
          -plan
          -draw-cycles
          -type
          -module-depth
        ] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:directory]]
      end
    end
  end
end
