require 'sinatra/base'
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
        class Expectation
          def executed!; @e = true; end
          def executed?; !!@e; end
          attr_reader :identifier
          def initialize(verb, path)
            @identifier = "_mock_ #{verb.to_s.upcase} #{path}"
          end
        end

        def mock(verb, path, &block)
          expectations << (expect = Expectation.new(verb, path))
          begin
            define_method(expect.identifier, &block)
            action = instance_method(expect.identifier)

            stub(verb, path) do |*args|
              expect.executed!
              action.bind(self).call(*args)
            end
          ensure
            remove_method(expect.identifier) if instance_methods.include?(expect.identifier)
          end
        end

        def verify
          raise Error unless expectations.all? {|mock| mock.executed? }
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

    def spy
      self.class.store(@request)
    end
    alias stump! spy
  end
end

