require 'rubygems'
require 'rack'

module Stumb
  autoload :Store,      'stumb/store'
  autoload :Stamp,      'stumb/stamp'
  autoload :StampSheet, 'stumb/stamp_sheet'
  autoload :Servlet,    'stumb/servlet'

  Version = '0.1.1'

  def to_app(sheet_path = "/sheet", &block)
    Rack::Builder.new {
      use Rack::ShowExceptions

      store = Store.new
      sheet = StampSheet.new(store)

      map(sheet_path) { run sheet }

      sinatra = Class.new(Servlet)
      sinatra.storage = store
      sinatra.class_eval(&block)

      map("/") { run sinatra }
    }
  end
  module_function :to_app
end

