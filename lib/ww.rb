require 'rubygems'
require 'rack'

module Ww
  autoload :Store,      'ww/store'
  autoload :Stamp,      'ww/stamp'
  autoload :StampSheet, 'ww/stamp_sheet'
  autoload :Servlet,    'ww/servlet'

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

