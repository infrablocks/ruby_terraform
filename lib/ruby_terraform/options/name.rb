# frozen_string_literal: true

require 'immutable-struct'

module RubyTerraform
  module Options
    class Name < ImmutableStruct.new(:name)
      def initialize(name)
        super(name: name.to_s)
      end

      def name
        "-#{without_prefix}"
      end

      alias to_s name

      def as_singular_key
        snake_case.to_sym
      end

      def as_plural_key
        :"#{snake_case}s"
      end

      private

      def without_prefix
        @name.sub(/^-+/, '')
      end

      def snake_case
        without_prefix.gsub('-', '_')
      end
    end
  end
end
