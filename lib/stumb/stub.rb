require 'rack'
require 'stumb/stamp'

module Stumb
  class Stub
    attr_reader :stamps
    def initialize(*stub_response)
      @stamps = []
      @stub_response = stub_response
    end

    def call(env)
      @stamps << Stamp.new(Rack::Request.new(env))
      @stub_response
    end
  end
end
