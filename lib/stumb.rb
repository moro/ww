require 'rubygems'
require 'rack'

module Stumb
  autoload :Stub,       'stumb/stub'
  autoload :Stamp,      'stumb/stamp'
  autoload :StampSheet, 'stumb/stamp_sheet'

  def to_app(response, sheet_path = "/sheet")
    Rack::Builder.new {
      use Rack::ShowExceptions

      stub = Stub.new(*response)
      sheet = StampSheet.new(stub)

      map(sheet_path) { run sheet }
      map("/") { run stub }
    }
  end
  module_function :to_app
end

