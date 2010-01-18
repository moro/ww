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

    def unbound_action(klass, mname, block)
      klass.module_eval do
        begin
          define_method(mname, &block)
          instance_method(mname)
        ensure
          remove_method(mname) if instance_methods.include?(mname)
        end
      end
    end
    module_function :unbound_action
  end
end
