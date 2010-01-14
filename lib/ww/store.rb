require 'monitor'
require 'forwardable'

module Ww
  class Store
    include Enumerable
    include MonitorMixin
    extend Forwardable

    def_delegators :storage, *[:size, :first, :last, :[], :empty?]

    def initialize
      super()
      @store = []
    end

    def storage
      synchronize { @store.dup }
    end

    def store(obj)
      synchronize{ @store << obj }
    end

    def each(descendant = true, &block)
      (descendant ? storage.reverse : storage).each(&block)
    end

    def clear!
      synchronize{ @store.clear }
    end
  end
end
