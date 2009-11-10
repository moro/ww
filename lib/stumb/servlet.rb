require 'sinatra'

module Stumb
  class Servlet < Sinatra::Base
    def self.store(req)
      @store.store(Stamp.new(req.dup))
    end

    def self.storage=(store)
      @store = store
    end

    def stump!
      self.class.store(@request)
    end
  end
end

