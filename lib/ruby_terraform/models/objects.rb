# frozen_string_literal: true

require_relative 'values'
require_relative 'path_set'

module RubyTerraform
  module Models
    # rubocop:disable Metrics/ModuleLength
    module Objects
      # rubocop:disable Metrics/ClassLength
      class << self
        # rubocop:disable Style/RedundantAssignment
        # rubocop:disable Metrics/MethodLength
        def box(object, unknown: nil, sensitive: nil)
          initial = boxed_empty_by_value(object)
          object = symbolise(object)
          unknown = symbolised_or_native_empty(unknown, object)
          sensitive = symbolised_or_native_empty(sensitive, object)

          return Values.unknown(sensitive: sensitive) if unknown == true

          unless object.is_a?(Hash) || object.is_a?(Array)
            return Values.known(object, sensitive: sensitive)
          end

          boxed_unknown =
            box_unknown(unknown, sensitive: sensitive, initial: initial)

          boxed_object =
            box_known(object, sensitive: sensitive, initial: boxed_unknown)

          boxed_object
        end
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Style/RedundantAssignment

        def paths(object)
          PathSet.extract_from(object)
        end

        def known_values(path_set, object: {}, sensitive: {})
          path_set.paths.map do |path|
            resolved = path.read(object)
            resolved_sensitive = path.read(sensitive) == true

            Values.known(resolved, sensitive: resolved_sensitive)
          end
        end

        def unknown_values(path_set, unknown: {}, sensitive: {})
          path_set.paths.map do |path|
            resolved = path.read(unknown)
            resolved_sensitive = path.read(sensitive) == true

            resolved ? Values.unknown(sensitive: resolved_sensitive) : nil
          end
        end

        def object(path_set, values,
                   sensitive: {},
                   initial: Values.empty_map,
                   filler: Values.omitted)
          gaps = path_set.gaps
          extra_values = gaps.paths.collect { |p| [p, filler] }

          path_values = path_set.paths.zip(values) + extra_values
          path_values = sort_by_path(path_values)

          update_all(initial, path_values, sensitive)
        end

        private

        def box_unknown(unknown, sensitive: {}, initial: Values.empty_map)
          path_set = paths(unknown)
          unknown_values = unknown_values(
            path_set, unknown: unknown, sensitive: sensitive
          )
          object(
            path_set, unknown_values, sensitive: sensitive, initial: initial
          )
        end

        def box_known(object, sensitive: {}, initial: Values.empty_map)
          path_set = paths(object)
          object_values = known_values(
            path_set, object: object, sensitive: sensitive
          )
          object(
            path_set, object_values, sensitive: sensitive, initial: initial
          )
        end

        def update_all(object, path_values, sensitive = {})
          path_values.each_with_object(object) do |path_value, obj|
            path, value = path_value
            update_in(obj, path, value, sensitive: sensitive)
          end
        end

        def update_in(object, path, value, sensitive: {})
          path.traverse(object) do |obj, step|
            update_object_for_step(
              obj, step, value, sensitive: sensitive
            )
          end
        end

        # rubocop:disable Metrics/MethodLength
        def update_object_for_step(object, step, value, sensitive: {})
          parent = step.seen.read(object, default: object)
          upcoming = step.remaining.first

          found_sensitive = step.seen.append(step.element).read(sensitive)
          resolved_sensitive = found_sensitive == true
          resolved =
            if step.remaining.empty?
              value
            else
              boxed_empty_by_key(upcoming, sensitive: resolved_sensitive)
            end

          parent[step.element] ||= resolved

          object
        end
        # rubocop:enable Metrics/MethodLength

        def boxed_empty_by_key(key, sensitive: false)
          if key.is_a?(Numeric)
            Values.empty_list(sensitive: sensitive)
          else
            Values.empty_map(sensitive: sensitive)
          end
        end

        def boxed_empty_by_value(value, sensitive: false)
          case value
          when Array then Values.empty_list(sensitive: sensitive)
          when Hash then Values.empty_map(sensitive: sensitive)
          end
        end

        def native_empty_by_value(value)
          case value
          when Array then []
          when Hash then {}
          else false
          end
        end

        def symbolise(object)
          case object
          when Hash
            object.to_h { |key, value| [key.to_sym, symbolise(value)] }
          else
            object
          end
        end

        def symbolised_or_native_empty(object, target)
          object ? symbolise(object) : native_empty_by_value(target)
        end

        def sort_by_path(path_values)
          path_values.sort { |a, b| a[0] <=> b[0] }
        end
      end
      # rubocop:enable Metrics/ClassLength
    end
    # rubocop:enable Metrics/ModuleLength
  end
end
