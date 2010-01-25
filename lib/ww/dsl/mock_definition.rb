require 'ww/dsl/definition_base'
require 'ww/double/mock/expectation'

module Ww
  module Dsl
    class MockDefinition < DefinitionBase
      def initialize(servlet, &block)
        super(servlet)
        @verification = block
      end

      private
      def expectation_for(verb, path, options)
        Double::Mock::Expectation.new(verb, path, @verification)
      end

      def define_action(verb, path, options = {}, &action)
        expect = expectation_for(verb, path, options)
        servlet.expectations << expect
        action = unbound_action(servlet, expect.identifier, action)

        servlet.stub.send(verb, path, options) do |*args|
          expect.verify(request, self.class.testing_thread)

          action.bind(self).call(*args)
        end
      end
    end
  end
end

