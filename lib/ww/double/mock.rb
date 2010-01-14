module Ww
  module Double
    module Mock
      class Expectation
        def executed!; @e = true; end
        def executed?; !!@e; end
        attr_reader :identifier
        def initialize(verb, path)
          @identifier = "_mock_ #{verb.to_s.upcase} #{path}"
        end
      end

      def mock(verb, path, &block)
        expectations << (expect = Expectation.new(verb, path))
        action = Double.unbound_action(self, expect.identifier, block)

        stub(verb, path) do |*args|
          expect.executed!
          action.bind(self).call(*args)
        end
      end

      def verify
        raise MockError unless expectations.all? {|mock| mock.executed? }
      end

      private
      def expectations
        @expectations ||= []
      end
    end
  end
end
