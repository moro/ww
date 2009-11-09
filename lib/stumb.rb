require 'rubygems'
require 'rack'

module Stumb
  autoload :Stub,       'stumb/stub'
  autoload :Stamp,      'stumb/stamp'
  autoload :StampSheet, 'stumb/stamp_sheet'
  autoload :Servlet,    'stumb/servlet'

  Version = '0.1.0'

  def to_app(sheet_path = "/sheet", &block)
    Rack::Builder.new {
      use Rack::ShowExceptions

      stub = Stub.new(200, {}, "")
      sheet = StampSheet.new(stub)

      map(sheet_path) { run sheet }

      sinatra = Class.new(Servlet)
      sinatra.storage = stub
      sinatra.class_eval(&block)

      map("/") { run sinatra }
    }
  end
  module_function :to_app
end

