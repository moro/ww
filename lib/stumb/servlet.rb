require 'sinatra'

module Stumb
  class Servlet < Sinatra::Base
    module Double
      def stub(verb, path, &block)
        send(verb, path, &block)
      end
    end

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
          k.class_eval(&block)
        end
      end
    end

    def stump!
      self.class.store(@request)
    end
  end
end

