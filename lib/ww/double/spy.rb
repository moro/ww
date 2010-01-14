require 'ww/store'
require 'ww/double/spy/request'

module Ww
  module Double
    module Spy
      def spy(verb, path, &block)
        action = Double.unbound_action(self, "_spy_ #{verb.to_s.upcase} #{path}", block)

        stub(verb, path) do |*args|
          spy!
          action.bind(self).call(*args)
        end
      end

      def requests
        @requests ||= Store.new
      end

      def store(req)
        requests.store(Request.new(req))
      end

      module InstanceMethods
        def spy!
          self.class.store(@request)
        end
        alias stump! spy!
      end
    end
  end
end
