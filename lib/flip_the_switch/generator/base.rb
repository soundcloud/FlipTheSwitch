module FlipTheSwitch
  module Generator
    class Base
      def initialize(output, features)
        @output = output
        @features = features
      end

      protected
      attr_reader :output, :features

      def all_features
        features
      end
    end
  end
end
