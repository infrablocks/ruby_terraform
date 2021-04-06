# frozen_string_literal: true

require_relative 'name'
require_relative 'types/boolean'
require_relative 'types/flag'
require_relative 'types/standard'

module RubyTerraform
  module Options
    class Factory
      PLURAL_OPTIONS =
        Set.new(
          %w[
            -var
            -target
            -var-file
            -platform
          ]
        ).freeze

      BOOLEAN_OPTIONS =
        Set.new(
          %w[
            -auto-approve
            -backend
            -get
            -get-plugins
            -input
            -list
            -lock
            -refresh
            -upgrade
            -verify-plugins
            -write
          ]
        ).freeze

      FLAG_OPTIONS =
        Set.new(
          %w[
            -allow-missing
            -allow-missing-config
            -check
            -compact-warnings
            -destroy
            -detailed-exitcode
            -diff
            -draw-cycles
            -force
            -force-copy
            -ignore-remote-version
            -json
            -no-color
            -raw
            -reconfigure
            -recursive
            -update
          ]
        ).freeze

      OVERRIDE_OPTIONS =
        {
          config: :directory,
          out: :plan
        }.freeze

      def self.from(names, parameters)
        new(names, parameters).from
      end

      private_class_method :new

      def initialize(names, parameters)
        @names = names.map { |name| Name.new(name) }
        @parameters = parameters
      end

      def from
        names.each_with_object([]) do |name, options|
          options.append(*options_from_name(name))
        end
      end

      private

      attr_reader :names, :parameters

      def options_from_name(name)
        return plural_options(name) if PLURAL_OPTIONS.include?(name)
        return boolean_option(name) if BOOLEAN_OPTIONS.include?(name)
        return flag_option(name) if FLAG_OPTIONS.include?(name)
        return override_option(name) if OVERRIDE_OPTIONS.key?(name.as_key)

        standard_option(name, name.as_key)
      end

      def boolean_option(name)
        [Types::Boolean.new(name.to_s, parameters[name.as_key])]
      end

      def flag_option(name)
        [Types::Flag.new(name.to_s, parameters[name.as_key])]
      end

      def standard_option(name, hash_key)
        [Types::Standard.new(name.to_s, parameters[hash_key])]
      end

      def override_option(name)
        standard_option(name, OVERRIDE_OPTIONS[name.as_key])
      end

      def plural_options(name)
        standard_option(name.to_s, name.as_key) +
          standard_option(name.to_s, name.as_plural_key)
      end
    end
  end
end
