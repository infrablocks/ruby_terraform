# frozen_string_literal: true

require_relative './values'
require_relative './path_set'

module RubyTerraform
  module Models
    # rubocop:disable Metrics/ModuleLength
    module Objects
      class << self
        # rubocop:disable Style/RedundantAssignment
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
          puts path_set.inspect

          path_values = path_set.paths.zip(values)
          path_values = sort_by_path(path_values)
          path_values = fill_gaps(path_values, filler)

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
          path.walk do |seen, step, remaining|
            pointer = [seen, step, remaining]
            update_object_for_step(object, pointer, value, sensitive: sensitive)
          end
          object
        end

        # rubocop:disable Metrics/MethodLength
        def update_object_for_step(object, pointer, value, sensitive: {})
          seen, step, remaining = pointer

          parent = seen.read(object, default: object)
          upcoming = remaining.first

          found_sensitive = seen.append(step).read(sensitive)
          resolved_sensitive = found_sensitive == true
          resolved =
            if remaining.empty?
              value
            else
              boxed_empty_by_key(upcoming, sensitive: resolved_sensitive)
            end

          parent[step] ||= resolved
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

        # rubocop:disable Metrics/MethodLength
        def fill_gaps(path_values, filler)
          result = path_values
                   .inject({ last: nil, filled: [] }) do |acc, path_value|
            puts '-------------------'
            current_path = path_value[0]
            last_path = acc[:last]

            require 'pp'
            puts 'Current path:'
            pp current_path
            puts 'Last path:'
            pp last_path

            last_indices = resolve_list_indices_between(last_path, current_path)
            current_indices = resolve_list_indices_in(current_path)

            puts 'Current indices:'
            pp current_indices
            puts 'Last indices:'
            pp last_indices

            extra_path_values =
              determine_extra_path_values(
                last_indices, current_indices, current_path, filler
              )

            puts 'Extra path values'
            pp extra_path_values

            {
              last: current_path,
              filled: acc[:filled] + extra_path_values + [path_value]
            }
          end

          result[:filled]
        end

        # rubocop:enable Metrics/MethodLength

        def resolve_list_indices_between(last, current)
          last_indices = last ? last.list_indices : []
          current_indices = current.list_indices
          puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
          puts 'Last indices:'
          pp last_indices
          puts 'Current indices:'
          pp current_indices

          thing = current_indices.inject([]) do |acc, current_entry|
            current_location, current_element = current_entry
            last_entry =
              last_indices
              .find(-> { [current_location, nil] }) do |last_index|
                last_index[0] == current_location
              end
            _, last_element = last_entry

            if (last_element && current_element < last_element) ||
               (last && !current.up_to_index(current_location)
                                .same_parent_collection?(
                                  last.up_to_index(current_location)
                                ))
              acc + [[current_location, nil]]
            else
              acc + [last_entry]
            end
          end

          puts 'Result:'
          pp thing
          puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

          thing
        end

        def resolve_list_indices_in(path)
          path.references_any_lists? ? path.list_indices : []
        end

        # rubocop:disable Metrics/MethodLength
        def determine_extra_path_values(
          last_indices, current_indices, current_path, filler
        )
          result = current_indices.each_with_index.inject([]) do |acc, entry|
            require 'pp'
            puts '++++++++++++++++++++'

            current_index, i = entry
            last_index = last_indices[i] || [nil, nil]
            last_element = last_index[1]
            current_location, current_element = current_index

            puts 'Current index:'
            pp current_index
            puts 'Last index:'
            pp last_index

            unless current_element.positive?
              puts 'Skipping as first in list'
              next(acc)
            end

            puts 'Continuing as need to check against last element'
            start_element = last_element.nil? ? 0 : last_element + 1

            if start_element == current_element
              puts 'Skipping as no gap found'
              next(acc)
            end

            puts 'Filling gap'
            acc += create_filler_path_values(
              start_element, current_element, current_path, current_location,
              filler
            )

            acc
          end

          puts '++++++++++++++++++++'

          result
        end

        # rubocop:enable Metrics/MethodLength

        def create_filler_path_values(from, to, path, location, filler)
          (from...to)
            .inject([]) do |pvs, list_element|
            new_path = path.up_to_index(location - 1)
                           .append(list_element)
            pvs + [[new_path, filler]]
          end
        end
      end
    end
    # rubocop:enable Metrics/ModuleLength
  end
end
