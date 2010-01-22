require 'ww/store'
require 'ww/double/spy/request'

module Ww
  module Double
    module Spy
      class DefinitionProxy < Double::DefinitionProxy
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

      def spy
        Spy::DefinitionProxy.new(self)
      end

      def spy_them_all!
        before { spy! }
      end

      def requests
        @requests ||= Store.new
      end

      def store(req)
        requests.store(Request.new(req))
      end

      module InstanceMethods
        def spy!
          self.class.store(@request) if @spyed ^ (@spyed = true)
        end
        alias stump! spy!
      end
    end
  end
end
