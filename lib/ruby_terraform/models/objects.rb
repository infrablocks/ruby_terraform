# frozen_string_literal: true

require_relative './values'

module RubyTerraform
  module Models
    # rubocop:disable Metrics/ModuleLength
    module Objects
      class << self
        # rubocop:disable Style/RedundantAssignment
        def box(object, unknown: {}, sensitive: {})
          boxed_unknown =
            box_unknown(unknown, sensitive: sensitive)
          boxed_object =
            box_known(object, sensitive: sensitive, initial: boxed_unknown)

          boxed_object
        end
        # rubocop:enable Style/RedundantAssignment

        def paths(object, current = [], accumulator = [])
          normalised = normalise(object)
          if normalised.is_a?(Enumerable)
            normalised.inject(accumulator) do |a, e|
              paths(e[0], current + [e[1]], a)
            end
          else
            accumulator + [current]
          end
        end

        def known_values(paths, object: {}, sensitive: {})
          paths.map do |path|
            resolved = try_dig(object, path)
            resolved_sensitive = try_dig(sensitive, path) == true

            Values.known(resolved, sensitive: resolved_sensitive)
          end
        end

        def unknown_values(paths, unknown: {}, sensitive: {})
          paths.map do |path|
            resolved = try_dig(unknown, path)
            resolved_sensitive = try_dig(sensitive, path) == true

            resolved ? Values.unknown(sensitive: resolved_sensitive) : nil
          end
        end

        private

        def box_unknown(unknown, sensitive: {}, initial: Values.empty_map)
          unknown_paths = paths(unknown)
          unknown_values = unknown_values(
            unknown_paths,
            unknown: unknown, sensitive: sensitive
          )

          object(
            unknown_paths, unknown_values,
            sensitive: sensitive, initial: initial
          )
        end

        def box_known(object, sensitive: {}, initial: Values.empty_map)
          object_paths = paths(object)
          object_values = known_values(
            object_paths,
            object: object, sensitive: sensitive
          )

          object(
            object_paths, object_values,
            sensitive: sensitive, initial: initial
          )
        end

        def object(paths, values, sensitive: {}, initial: Values.empty_map)
          paths
            .zip(values)
            .each_with_object(initial) do |path_value, object|
            path, value = path_value
            update_in(object, path, value, sensitive: sensitive)
          end
        end

        def update_in(object, path, value, sensitive: {})
          path.inject([[], path.drop(1)]) do |context, step|
            seen, remaining = context
            pointer = [seen, step, remaining]

            update_object_for_step(object, pointer, value, sensitive: sensitive)
            update_context_for_step(pointer)
          end
          object
        end

        def update_object_for_step(object, pointer, value, sensitive: {})
          seen, step, remaining = pointer

          parent = try_dig(object, seen, default: object)
          upcoming = remaining.first

          resolved_sensitive = try_dig(sensitive, seen + [step]) == true
          resolved = if remaining.empty?
                       value
                     else
                       empty_by_type(upcoming, sensitive: resolved_sensitive)
                     end

          parent[step] ||= resolved
        end

        def update_context_for_step(pointer)
          seen, step, remaining = pointer
          [seen + [step], remaining.drop(1)]
        end

        def try_dig(object, path, default: nil)
          return default if path.empty?

          result = object.dig(*path)
          result.nil? ? default : result
        rescue NoMethodError, TypeError
          default
        end

        def empty_by_type(value, sensitive: false)
          if value.is_a?(Numeric)
            Values.empty_list(sensitive: sensitive)
          else
            Values.empty_map(sensitive: sensitive)
          end
        end

        def normalise(object)
          case object
          when Array then object.each_with_index.to_a
          when Hash then object.to_a.map { |e| [e[1], e[0]] }
          else object
          end
        end
      end
    end
    # rubocop:enable Metrics/ModuleLength
  end
end
