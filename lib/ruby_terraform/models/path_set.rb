# frozen_string_literal: true

require_relative '../value_equality'

module RubyTerraform
  module Models
    class PathSet
      class << self
        def empty
          new([])
        end

        def extract_from(object)
          empty.add_paths_from(object)
        end
      end

      extend Forwardable

      include ValueEquality

      def_delegators(:@paths, :empty?)

      attr_reader(:paths)

      def initialize(paths)
        @paths = paths
      end

      def add_paths_from(object)
        self.class.new(paths + extract_paths_from(object))
      end

      def gaps
        initial_context = { last: Path.new([]), complete: [] }
        result = paths.sort.inject(initial_context) do |acc, path|
          current_path = path
          last_path = acc[:last]
          missing_paths = determine_missing_paths(last_path, current_path)
          updated_paths = acc[:complete] + missing_paths

          { last: current_path, complete: updated_paths }
        end

        self.class.new(result[:complete])
      end

      def state
        [paths]
      end

      private

      def extract_paths_from(
        object,
        current = Path.new([]),
        accumulator = []
      )
        normalised = normalise(object)
        if normalised.is_a?(Enumerable)
          normalised.inject(accumulator) do |a, e|
            extract_paths_from(e[0], current.append(e[1]), a)
          end
        else
          accumulator + [current]
        end
      end

      def normalise(object)
        case object
        when Array then object.each_with_index.to_a
        when Hash
          object.to_a.map do |e|
            [e[1], e[0].to_sym]
          end
        else
          object
        end
      end

      # rubocop:disable Metrics/MethodLength
      def determine_missing_paths(last_path, current_path)
        last_indices = resolve_last_indices(last_path, current_path)
        current_indices = current_path.list_indices

        current_indices.inject([]) do |acc, current_index|
          current_location, current_element = current_index
          last_index =
            last_indices.find { |index| index[0] == current_location }
          last_element = last_index[1]

          next(acc) unless current_element.positive?

          start_element = last_element.nil? ? 0 : last_element + 1
          next(acc) if start_element == current_element

          acc + create_missing_paths(
            start_element, current_element, current_path, current_location
          )
        end
      end
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Metrics/MethodLength
      def resolve_last_indices(last_path, current_path)
        last_indices = last_path.list_indices
        current_indices = current_path.list_indices

        current_indices.collect do |current_entry|
          location, current_element = current_entry
          last_entry = last_indices.find { |index| index[0] == location }
          last_element = last_entry&.slice(1)
          reset_entry = [location, nil]

          next(reset_entry) unless last_element
          next(reset_entry) if current_element < last_element

          current_sub_path = current_path.to_location(location)
          last_sub_path = last_path.to_location(location)

          unless current_sub_path.same_parent_collection?(last_sub_path)
            next(reset_entry)
          end

          last_entry
        end
      end
      # rubocop:enable Metrics/MethodLength

      def create_missing_paths(from, to, path, location)
        (from...to).collect do |element|
          path.before_location(location).append(element)
        end
      end
    end
  end
end
