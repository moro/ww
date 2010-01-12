require 'sinatra'
require 'monitor'

module Stumb
  class Servlet < Sinatra::Base
    module Double
      class Error < RuntimeError; end

      def self.extended(base)
        base.extend Stub
        base.extend Mock
      end

      module Mock
        def mock(verb, path, &block)
          v = verb.to_s.upcase
          ident = [verb, path]
          expectations << ident

          action = Proc.new do |*args|
            self.class.consume(ident)
            instance_eval(&block)
          end
          stub(verb, path, &action)
        end

        def finish
          raise Error unless expectations.empty?
        end

        # TODO refactor
        def consume(ident)
          synchronize do
            pos = expectations.index(expectations.detect {|m| m.eql?(ident) })
            expectations.delete_at(pos)
          end
        end

        private
        def expectations
          @expectations ||= []
        end
      end

      module Stub
        def stub(verb, path, &block)
          v = verb.to_s.upcase

          synchronize do
            send(verb, path, &block)
            routes[v].unshift(routes[v].pop)
          end
        end
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
          k.extend MonitorMixin
          k.class_eval(&block)
        end
      end
    end

    def stump!
      self.class.store(@request)
    end
  end
end

