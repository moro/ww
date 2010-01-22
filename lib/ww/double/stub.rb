require 'ww/double/definition_proxy'

module Ww
  module Double
    module Stub
      class DefinitionProxy < Double::DefinitionProxy
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

      def stub
        Stub::DefinitionProxy.new(self)
      end
    end
  end
end
