# frozen_string_literal: true

require_relative './random'

module Support
  module Build
    class << self
      def no_op_change_content(overrides = {})
        change_content(overrides.merge(actions: ['no-op']))
      end

      def create_change_content(overrides = {})
        change_content(overrides.merge(actions: ['create']))
      end

      def read_change_content(overrides = {})
        change_content(overrides.merge(actions: ['read']))
      end

      def update_change_content(overrides = {})
        change_content(overrides.merge(actions: ['update']))
      end

      def replace_delete_before_create_change_content(overrides = {})
        change_content(overrides.merge(actions: %w[delete create]))
      end

      def replace_create_before_delete_change_content(overrides = {})
        change_content(overrides.merge(actions: %w[create delete]))
      end

      def delete_change_content(overrides = {})
        change_content(overrides.merge(actions: ['delete']))
      end

      # rubocop:disable Metrics/MethodLength
      def change_content(overrides = {})
        {
          actions: ['create'],
          before: {},
          after: {
            standard_attribute: 'value1',
            sensitive_attribute: 'value2'
          },
          after_unknown: {
            unknown_attribute: true
          },
          before_sensitive: {},
          after_sensitive: {
            sensitive_attribute: true
          }
        }.merge(overrides)
      end
      # rubocop:enable Metrics/MethodLength

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
          ]
        }.merge(overrides)
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
