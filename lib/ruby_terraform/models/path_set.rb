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

      def state
        [paths]
      end

      def inspect
        paths.inject([]) { |acc, path| acc + [path.inspect] }.join("\n")
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
    end
  end
end
