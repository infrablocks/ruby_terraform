# frozen_string_literal: true

require_relative '../value_equality'
require_relative 'resource_change'
require_relative 'output_change'

module RubyTerraform
  module Models
    class Plan
      include ValueEquality

      def initialize(content)
        @content = content
      end

      def format_version
        @content[:format_version]
      end

      def terraform_version
        @content[:terraform_version]
      end

      def variables
        @content[:variables]
      end

      def variable_values
        variables.transform_values { |value| value[:value] }
      end

      def resource_changes
        @content[:resource_changes].map do |resource_change|
          ResourceChange.new(resource_change)
        end
      end

      def resource_changes_matching(definition)
        resource_changes.filter do |resource_change|
          definition.all? do |method, value|
            resource_change.send(method) == value
          end
        end
      end

      def output_changes
        @content[:output_changes].map do |output_name, output_change|
          OutputChange.new(output_name, output_change)
        end
      end

      def output_changes_matching(definition)
        output_changes.filter do |output_change|
          definition.all? do |method, value|
            output_change.send(method) == value
          end
        end
      end

      def inspect
        @content.inspect
      end

      def to_h
        @content
      end

      def state
        [@content]
      end
    end
  end
end
