module Ww
  module Double
    module Mock
      class Expectation
        def executed!; @e = true; end
        def executed?; !!@e; end
        attr_reader :identifier

        def initialize(verb, path, options)
          @identifier = "_mock_ #{verb.to_s.upcase} #{path}"
          @verifyer = options[:verify]
        end

        def expecting_request?(request)
          return true unless @verifyer
          r = request.dup
          @verifyer.call(r, r.params)
        end
      end

      def testing_thread=(thread)
        @testing_thread = thread
      end

      def testing_thread
        @testing_thread
      end

      def mock(verb, path, options = {}, &block)
        expectations << (expect = Expectation.new(verb, path, options))
        action = Double.unbound_action(self, expect.identifier, block)

        stub(verb, path) do |*args|
          expect.executed!
          unless expect.expecting_request?(request)
            tt = self.class.testing_thread
            tt && tt.raise(MockError)
          end
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
