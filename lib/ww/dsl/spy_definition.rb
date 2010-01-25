require 'ww/dsl/definition_base'

module Ww
  module Dsl
    class SpyDefinition < Ww::Dsl::DefinitionBase
      private
      def define_action(verb, path, options = {}, &action)
        ident =  "_spy_ #{verb.to_s.upcase} #{path}"
        action = unbound_action(servlet, ident, action)

        servlet.stub.send(verb, path, options) do |*args|
          spy!
          action.bind(self).call(*args)
        end
      end
    end
  end
end
