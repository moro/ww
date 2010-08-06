require 'rack'
require 'forwardable'
require 'time'
require 'haml'

module Ww
  autoload :Servlet, 'ww/servlet'
  class SpyEye
    class << self
      def to_app(spy_eye_path = "/spy", &block)
        Rack::Builder.new {
          use Rack::ShowExceptions

          servlet = Servlet.base(&block)
          spy = SpyEye.new(servlet)

          map(spy_eye_path) { run spy }
          map("/") { run servlet }
        }
      end
    end

    extend Forwardable
    def_delegator :@servlet, :requests

    def initialize(servlet)
      @servlet = servlet
    end

    def call(env)
      [200, {"Content-Type" => "text/html"}, [template.render(self)]]
    end

    private
    def template
      path = ::File.expand_path("spy_eye.html.haml", ::File.dirname(__FILE__))
      Haml::Engine.new(::File.read(path))
    end
  end
end

