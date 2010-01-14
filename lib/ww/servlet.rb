require 'sinatra/base'
require 'monitor'

module Ww
  autoload :Double, 'ww/double'

  class Servlet < Sinatra::Base
    class << self
      def store(req)
        @store.store(Stamp.new(req.dup))
      end

      def storage=(store)
        @store = store
      end

      def base(&block)
        Class.new(self).tap do |k|
          k.extend Double
          k.extend MonitorMixin
          k.class_eval(&block)
        end
      end
    end

    def spy
      self.class.store(@request)
    end
    alias stump! spy
  end
end

