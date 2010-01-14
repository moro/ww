require 'rubygems'
require 'rack'

module Ww
  autoload :Servlet, 'ww/servlet'
  autoload :SpyEye,  'ww/spy_eye'

  Version = '0.2.0'

  def to_app(spy_eye_path = "/spy", &block)
    Rack::Builder.new {
      use Rack::ShowExceptions

      servlet = Servlet.base(&block)
      spy = SpyEye.new(servlet)

      map(spy_eye_path) { run spy }
      map("/") { run servlet }
    }
  end
  module_function :to_app
end

