module RubyTerraform
  module Options
    class Switch
      def initialize(switch)
        @switch_without_prefix = switch[0] == '-' ? switch[1..] : switch
      end

      def to_s
        "-#{switch_without_prefix}"
      end

      def as_key
        snake_case.to_sym
      end

      def as_plural_key
        "#{snake_case}s".to_sym
      end

      def ==(other)
        to_s == other
      end

      def eql?(other)
        to_s == other
      end

      def hash
        to_s.hash
      end

      private

      attr_reader :switch_without_prefix

      def snake_case
        switch_without_prefix.gsub('-', '_')
      end
    end
  end
end
