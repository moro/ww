require 'rubygems'
require 'rack'

module Stumb
  autoload :Stub,       'stumb/stub'
  autoload :Stamp,      'stumb/stamp'
  autoload :StampSheet, 'stumb/stamp_sheet'

  Version = '0.0.4'

  def to_app(response, sheet_path = "/sheet", &block)
    Rack::Builder.new {
      use Rack::ShowExceptions

      stub = Stub.new(*response)
      sheet = StampSheet.new(stub)

      map(sheet_path) { run sheet }
      yield self, stub if block_given?
      map("/") { run stub }
    }
  end
  module_function :to_app
end

