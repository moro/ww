require 'monitor'

module Stumb
  class Store
    include Enumerable
    include MonitorMixin

    def initialize
      super()
      @store = []
    end

    def store(obj)
      synchronize{ @store << obj }
    end

    def each(descendant = true, &block)
      store = synchronize{ @store.dup }
      (descendant ? store.reverse : store).each(&block)
    end

    def size
      synchronize{ @store.size }
    end

    def clear!
      @store.clear
    end
  end
end
