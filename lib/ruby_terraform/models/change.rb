# frozen_string_literal: true

require_relative '../value_equality'
require_relative './objects'

module RubyTerraform
  module Models
    class Change
      include ValueEquality

      def initialize(content)
        @content = symbolise_keys(content)
      end

      def actions
        @content[:actions].map do |action|
          {
            'no-op' => :no_op,
            'create' => :create,
            'read' => :read,
            'update' => :update,
            'delete' => :delete
          }[action]
        end
      end

      def before
        @content[:before]
      end

      def before_sensitive
        @content[:before_sensitive]
      end

      def before_object
        Objects.box(before, sensitive: before_sensitive)
      end

      def after
        @content[:after]
      end

      def after_unknown
        @content[:after_unknown]
      end

      def after_sensitive
        @content[:after_sensitive]
      end

      def after_object
        Objects.box(
          after,
          unknown: after_unknown,
          sensitive: after_sensitive
        )
      end

      def no_op?
        actions == [:no_op]
      end

      def create?
        actions == [:create]
      end

      def read?
        actions == [:read]
      end

      def update?
        actions == [:update]
      end

      def replace_delete_before_create?
        actions == %i[delete create]
      end

      def replace_create_before_delete?
        actions == %i[create delete]
      end

      def replace?
        replace_delete_before_create? || replace_create_before_delete?
      end

      def delete?
        actions == [:delete]
      end

      def inspect
        @content.inspect
      end

      def to_h
        @content
      end

      def state
        [@content]
      end

      private

      def symbolise_keys(object)
        if object.is_a?(Hash)
          object.to_h { |k, v| [k.to_sym, symbolise_keys(v)] }
        else
          object
        end
      end
    end
  end
end
