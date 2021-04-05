module RubyTerraform
  module Options
    class Name
      def initialize(name)
        @name = name
      end

      def without_prefix
        @name[0] == '-' ? @name[1..] : @name
      end

      def to_s
        "-#{without_prefix}"
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

      def snake_case
        without_prefix.gsub('-', '_')
      end
    end
  end
end
