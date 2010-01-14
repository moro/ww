require 'haml'
require 'time'

module Ww
  class StampSheet
    attr_reader :store

    def initialize(store)
      @store = store
    end

    def call(env)
      [200, {"Content-Type" => "text/html"}, template.render(self)]
    end

    private
    def template
      path = ::File.expand_path("sheet.html.haml", ::File.dirname(__FILE__))
      Haml::Engine.new(::File.read(path))
    end
  end
end

