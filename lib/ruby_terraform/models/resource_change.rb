# frozen_string_literal: true

require_relative '../value_equality'
require_relative 'change'

module RubyTerraform
  module Models
    class ResourceChange
      include ValueEquality

      def initialize(content)
        @content = symbolise_keys(content)
      end

      def address
        @content[:address]
      end

      def module_address
        @content[:module_address]
      end

      def mode
        @content[:mode]
      end

      def type
        @content[:type]
      end

      def name
        @content[:name]
      end

      def index
        @content[:index]
      end

      def provider_name
        @content[:provider_name]
      end

      def change
        Change.new(@content[:change])
      end

      def no_op?
        change.no_op?
      end

      def create?
        change.create?
      end

      def read?
        change.read?
      end

      def update?
        change.update?
      end

      def replace_delete_before_create?
        change.replace_delete_before_create?
      end

      def replace_create_before_delete?
        change.replace_create_before_delete?
      end

      def replace?
        change.replace?
      end

      def delete?
        change.delete?
      end

      def present_before?
        no_op? || read? || update? || replace? || delete?
      end

      def present_after?
        no_op? || read? || create? || update? || replace?
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
