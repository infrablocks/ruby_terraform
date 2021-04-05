require_relative 'switch'
require_relative 'boolean'
require_relative 'flag'
require_relative 'standard'

module RubyTerraform
  module Options
    class Factory
      PLURAL_SWITCHES =
        Set.new(
          %w[
              -var
              -target
              -var-file
            ]
        ).freeze

      BOOLEAN_SWITCHES =
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

      FLAG_SWITCHES =
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

      OVERRIDE_SWITCHES =
        {
          config: :directory,
          out: :plan
        }.freeze

      def self.from(values, switches)
        new(values, switches).from
      end

      private_class_method :new

      def initialize(values, switches)
        @switches = switches.map { |switch| Switch.new(switch) }
        @values = values
      end

      def from
        switches.each_with_object([]) do |switch, options|
          options.append(*options_from_switch(switch))
        end
      end

      private

      attr_reader :switches, :values

      def options_from_switch(switch)
        return plural_options(switch) if PLURAL_SWITCHES.include?(switch)
        return boolean_option(switch) if BOOLEAN_SWITCHES.include?(switch)
        return flag_option(switch) if FLAG_SWITCHES.include?(switch)
        return override_option(switch) if OVERRIDE_SWITCHES.key?(switch.as_key)

        standard_option(switch, switch.as_key)
      end

      def boolean_option(switch)
        [Boolean.new(switch.to_s, values[switch.as_key])]
      end

      def flag_option(switch)
        [Flag.new(switch.to_s, values[switch.as_key])]
      end

      def standard_option(switch, hash_key)
        [Standard.new(switch.to_s, values[hash_key])]
      end

      def override_option(switch)
        standard_option(switch, OVERRIDE_SWITCHES[switch.as_key])
      end

      def plural_options(switch)
        standard_option(switch.to_s, switch.as_key) +
          standard_option(switch.to_s, switch.as_plural_key)
      end
    end
  end
end
