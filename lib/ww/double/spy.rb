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
        @requests ||= []
      end

      module InstanceMethods
        def spy!
          self.class.requests << @request
        end
      end
    end
  end
end
