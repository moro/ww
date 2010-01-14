require 'ww/double/mock'
require 'ww/double/stub'

module Ww
  module Double
    class Error < RuntimeError; end
    class MockError < Error ; end

    include Stub
    include Mock

    def unbound_action(klass, mname, block)
      ret = nil
      klass.module_eval do
        begin
          define_method(mname, &block)
          ret = instance_method(mname)
        ensure
          remove_method(mname) if instance_methods.include?(mname)
        end
      end
      return ret
    end
    module_function :unbound_action
  end
end
