require 'ww/servlet'
require 'forwardable'

module Ww
  class Application
    extend Forwardable
    attr_reader :current
    def_delegators :current, :call

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
