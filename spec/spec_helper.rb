require 'rubygems'
require 'sinatra'
$: << File.expand_path("../lib", File.dirname(__FILE__))

module WwSpec
  module ExampleMethods
    def servlet_defining_get_root
      Ww::Servlet.base do
        get("/") do
          response.status = 200
          response["Content-Type"] = "text/plain"
          response.body = "Hello World"
        end
      end
    end
  end
end

Spec::Runner.configure do |config|
  config.include WwSpec::ExampleMethods
end
 
