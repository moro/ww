require 'ww/dsl/definition_base'

module Ww
  module Dsl
    class StubDefinition < DefinitionBase
      private
      def define_action(verb, path, options = {}, &action)
        v = verb.to_s.upcase
        servlet.synchronize do
          servlet.send(verb, path, options, &action)
          routes = servlet.routes
          routes[v].unshift(routes[v].pop)
        end
      end
    end
  end
end
