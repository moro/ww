require 'rubygems'
require 'rack'

module Ww
  autoload :Servlet,    'ww/servlet'
  autoload :StampSheet, 'ww/stamp_sheet'

  Version = '0.2.0'

  def to_app(sheet_path = "/sheet", &block)
    Rack::Builder.new {
      use Rack::ShowExceptions

      servlet = Servlet.base(&block)
      sheet = StampSheet.new(servlet)

      map(sheet_path) { run sheet }
      map("/") { run servlet }
    }
  end
  module_function :to_app
end

