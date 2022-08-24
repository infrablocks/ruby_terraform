# frozen_string_literal: true

module Support
  module Transform
    class << self
      def stringify_keys(object)
        if object.is_a?(Hash)
          object.to_h { |k, v| [k.to_s, stringify_keys(v)] }
        else
          object
        end
      end

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
