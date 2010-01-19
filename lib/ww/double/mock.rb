module Ww
  module Double
    module Mock
      class Expectation
        def executed!; @e = true; end
        def executed?; !!@e; end
        attr_reader :identifier

        def initialize(verb, path, verifier = nil)
          @identifier = "_mock_ #{verb.to_s.upcase} #{path}"
          @verifier = verifier
        end

        def verify(request, testing_thread = nil)
          return true unless @verifier && testing_thread # no need to verify
          return true if @verifier.call(r = request.dup, r.params)

          testing_thread.raise MockError
        end
      end

      def testing_thread=(thread)
        @testing_thread = thread
      end

      def testing_thread
        @testing_thread
      end

      def mock(verb, path, options = {}, &block)
        expect = Expectation.new(verb, path, options.delete(:verify))
        expectations << expect
        action = Double.unbound_action(self, expect.identifier, block)

        stub(verb, path) do |*args|
          expect.verify(request, self.class.testing_thread)
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
