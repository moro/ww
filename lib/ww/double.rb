require 'ww/double/stub'
require 'ww/double/mock'
require 'ww/double/spy'

module Ww
  module Double
    class Error < RuntimeError; end
    class MockError < Error ; end

    MODULES = [Stub, Mock, Spy].each do |mod|
      include mod
    end

    def self.extended(base)
      MODULES.each do |mod|
        base.send(:include, mod::InstanceMethods) if mod.const_defined?("InstanceMethods")
      end
    end
  end
end
