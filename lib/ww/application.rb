require 'ww/servlet'
require 'forwardable'

module Ww
  class Application
    extend Forwardable

    def_delegators :current, :call
    def_delegators :current, :stub, :mock, :spy

    attr_reader :current

    def initialize(&servlet_initializer)
      @servlet_initializer = servlet_initializer
      reset!
    end

    def reset!
      @current = build_servlet
    end

    private
    def build_servlet
      Servlet.base(&@servlet_initializer)
    end
  end
end
