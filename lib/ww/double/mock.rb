require 'ww/dsl/mock_definition'

module Ww
  module Double
    module Mock
      def testing_thread=(thread)
        @testing_thread = thread
      end

      def testing_thread
        @testing_thread
      end

      def mock(args = nil, &block)
        Dsl::MockDefinition.new(self, args, &block)
      end

      def verify
        raise MockError unless expectations.all? {|mock| mock.executed? }
      end

      def expectations
        @expectations ||= []
      end
    end
  end
end
