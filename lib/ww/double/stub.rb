require 'ww/dsl/stub_definition'

module Ww
  module Double
    module Stub
      def stub
        Dsl::StubDefinition.new(self)
      end
    end
  end
end
