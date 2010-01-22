require 'forwardable'
require 'ww/double/definition_proxy'

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

      class MockDefinitionProxy < DefinitionProxy
        def initialize(servlet, &block)
          super(servlet)
          @verification = block
        end

        private
        def expectation_for(verb, path, options)
          Expectation.new(verb, path, @verification)
        end

        def define_action(verb, path, options = {}, &action)
          expect = expectation_for(verb, path, options)
          servlet.expectations << expect
          action = unbound_action(servlet, expect.identifier, action)

          # FIXME
          servlet.stub(verb, path) do |*args|
            expect.verify(request, self.class.testing_thread)
            expect.executed!

            action.bind(self).call(*args)
          end
        end
      end

      def mock(&block)
        MockDefinitionProxy.new(self, &block)
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
