require 'ww/double/mock'
require 'ww/double/stub'

module Ww
  module Double
    class Error < RuntimeError; end
    class MockError < Error ; end

    include Stub
    include Mock
  end
end
