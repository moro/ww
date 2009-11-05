require 'haml'
require 'time'

module Stumb
  class StampSheet
    def initialize(stub)
      @stub = stub
    end

    def call(env)
      [200, {"Content-Type" => "text/html"}, template.render(@stub)]
    end

    private
    def template
      path = ::File.expand_path("sheet.html.haml", ::File.dirname(__FILE__))
      Haml::Engine.new(::File.read(path))
    end
  end
end

