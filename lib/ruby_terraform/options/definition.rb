# frozen_string_literal: true

require 'immutable-struct'

require_relative 'name'
require_relative 'types'
require_relative 'values'

module RubyTerraform
  module Options
    # rubocop:disable Metrics/ClassLength
    class Definition < ImmutableStruct.new(
      :name,
      :option_type,
      :value_type,
      :override_keys,
      :extra_keys,
      :separator,
      :repeatable?
    )
      def initialize(opts) # rubocop:disable Metrics/MethodLength
        raise 'Missing name' unless opts[:name]

        super(
          name: Name.new(opts[:name]),
          option_type: Types.resolve(opts[:option_type]) || Types::Standard,
          value_type: Values.resolve(opts[:value_type]) || Values::String,
          repeatable: opts[:repeatable] || false,
          separator: opts[:separator],
          extra_keys:
            { singular: [], plural: [] }
              .merge(opts[:extra_keys] || {}),
          override_keys:
            { singular: nil, plural: nil }
              .merge(opts[:override_keys] || {})
        )
      end

      def matches?(name)
        @name == Name.new(name)
      end

      def build(parameters)
        build_singular_options(parameters) + build_plural_options(parameters)
      end

      private

      def resolved_singular_key
        if override_keys[:singular] == false
          nil
        else
          override_keys[:singular] || name.as_singular_key
        end
      end

      def all_singular_keys
        ([resolved_singular_key] + extra_keys[:singular]).compact
      end

      def resolved_plural_key
        if override_keys[:plural] == false
          nil
        else
          override_keys[:plural] || name.as_plural_key
        end
      end

      def all_plural_keys
        ([resolved_plural_key] + extra_keys[:plural]).compact
      end

      def too_many_values?(values)
        !repeatable? && values.length > 1
      end

      def values(parameters, keys)
        keys.map { |k| parameters[k] }.compact
      end

      def needs_plural?(value)
        repeatable? && !value.nil?
      end

      def only_singular?(value)
        !needs_plural?(value)
      end

      def key_valued?(value)
        value.respond_to?(:keys)
      end

      def multi_valued?(value)
        value.respond_to?(:each)
      end

      def build_option(value)
        option_type.new(name, value, separator: separator)
      end

      def build_value(value)
        value_type.new(value)
      end

      def build_key_value(key, value)
        Values::KeyValue.new(key, build_value(value))
      end

      def build_singular(value)
        value.nil? ? build_no_options : build_single_option(value)
      end

      def build_singulars(values)
        values.map { |p| build_singular(p) }.flatten
      end

      def build_singular_options(parameters)
        keys = all_singular_keys
        values = values(parameters, keys)

        if too_many_values?(values)
          raise "Multiple values provided for '#{name}' " \
                "(with keys #{keys}) and option not repeatable."
        end

        build_singulars(values)
      end

      def build_plural(value)
        if only_singular?(value)
          build_no_options
        elsif key_valued?(value)
          build_key_value_options(value)
        elsif multi_valued?(value)
          build_multiple_options(value)
        else
          build_single_option(value)
        end
      end

      def build_plurals(values)
        values.map { |p| build_plural(p) }.flatten
      end

      def build_plural_options(parameters)
        keys = all_plural_keys
        values = values(parameters, keys)

        build_plurals(values)
      end

      def build_key_value_options(value)
        value.map { |k, v| build_option(build_key_value(k, v)) }
      end

      def build_multiple_options(value)
        value.map { |v| build_option(build_value(v)) }
      end

      def build_single_option(value)
        [build_option(build_value(value))]
      end

      def build_no_options
        []
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
