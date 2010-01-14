require 'sinatra/base'
require 'monitor'

module Ww
  autoload :Double, 'ww/double'

  class Servlet < Sinatra::Base
    class << self
      def base(&block)
        Class.new(self).tap do |k|
          k.extend Double
          k.extend MonitorMixin
          k.class_eval(&block)
        end
      end
    end
  end
end

