# frozen_string_literal: true

require_relative './random'

module Support
  # rubocop:disable Metrics/ModuleLength
  module Build
    class << self
      def change_content_defaults_for_resource
        { actions: ['create'],
          before: {},
          after: {
            standard_attribute: Support::Random.alphanumeric_string,
            sensitive_attribute: Support::Random.alphanumeric_string
          },
          after_unknown: { unknown_attribute: true },
          before_sensitive: {},
          after_sensitive: { sensitive_attribute: true } }
      end

      def change_content_defaults_for_output
        { actions: ['create'],
          before: nil,
          before_sensitive: false,
          after: Support::Random.alphanumeric_string,
          after_unknown: false,
          after_sensitive: false }
      end

      def change_content_defaults(type)
        case type
        when :resource then change_content_defaults_for_resource
        when :output then change_content_defaults_for_output
        else {}
        end
      end

      def no_op_change_content(overrides = {})
        change_content(overrides.merge(actions: ['no-op']))
      end

      def create_change_content(overrides = {}, opts = {})
        change_content(overrides.merge(actions: ['create']), opts)
      end

      def read_change_content(overrides = {})
        change_content(overrides.merge(actions: ['read']))
      end

      def update_change_content(overrides = {}, opts = {})
        change_content(overrides.merge(actions: ['update']), opts)
      end

      def replace_delete_before_create_change_content(overrides = {})
        change_content(overrides.merge(actions: %w[delete create]))
      end

      def replace_create_before_delete_change_content(overrides = {})
        change_content(overrides.merge(actions: %w[create delete]))
      end

      def delete_change_content(overrides = {}, opts = {})
        change_content(overrides.merge(actions: ['delete']), opts)
      end

      def change_content(overrides = {}, opts = {})
        change_content_defaults(opts[:type] || :resource).merge(overrides)
      end

      # rubocop:disable Metrics/MethodLength
      def resource_change_content(
        overrides = {},
        opts = {}
      )
        opts = {
          module_resource: false,
          multi_instance_resource: false
        }.merge(opts)

        resource_provider_name = Support::Random.provider_name
        resource_type = Support::Random.resource_type
        resource_name = Support::Random.resource_name
        resource_index = Support::Random.resource_index
        resource_module_address = Support::Random.module_address
        resource_address =
          if opts[:module_resource]
            "#{resource_module_address}.#{resource_type}.#{resource_name}"
          else
            "#{resource_type}.#{resource_name}"
          end

        defaults = {
          address: resource_address,
          mode: 'managed',
          type: resource_type,
          name: resource_name,
          provider_name: resource_provider_name,
          change: change_content
        }

        if opts[:module_resource]
          defaults = defaults.merge(module_address: resource_module_address)
        end

        if opts[:multi_instance_resource]
          defaults = defaults.merge(index: resource_index)
        end

        defaults.merge(overrides)
      end

      # rubocop:enable Metrics/MethodLength

      def output_change_content(overrides = {})
        change_content(overrides, { type: :output })
      end

      def variable_content(overrides = {})
        {
          value: Support::Random.alphanumeric_string
        }.merge(overrides)
      end

      # rubocop:disable Metrics/MethodLength
      def plan_content(overrides = {})
        {
          format_version: '1.0',
          terraform_version: '1.1.5',
          variables: {
            variable1: variable_content,
            variable2: variable_content
          },
          resource_changes: [
            Support::Build.resource_change_content,
            Support::Build.resource_change_content
          ],
          output_changes: {
            Support::Random.output_name =>
              Support::Build.output_change_content,
            Support::Random.output_name =>
              Support::Build.output_change_content
          }
        }.merge(overrides)
      end

      # rubocop:enable Metrics/MethodLength
    end
  end
  # rubocop:enable Metrics/ModuleLength
end
