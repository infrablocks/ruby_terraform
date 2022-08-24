# frozen_string_literal: true

require_relative '../value_equality'
require_relative 'change'

module RubyTerraform
  module Models
    class OutputChange
      include ValueEquality

      def initialize(name, content)
        @name = name.to_sym
        @content = symbolise_keys(content)
      end

      def name
        @name.to_s
      end

      def change
        Change.new(@content)
      end

      def no_op?
        change.no_op?
      end

      def create?
        change.create?
      end

      def update?
        change.update?
      end

      def delete?
        change.delete?
      end

      def present_before?
        no_op? || update? || delete?
      end

      def present_after?
        no_op? || create? || update?
      end

      def inspect
        to_h.inspect
      end

      def to_h
        { @name => @content }
      end

      def state
        [@name, @content]
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
