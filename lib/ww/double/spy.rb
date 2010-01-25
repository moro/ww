require 'ww/store'
require 'ww/double/spy/request'
require 'ww/dsl/spy_definition'

module Ww
  module Double
    module Spy
      def spy
        Dsl::SpyDefinition.new(self)
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
