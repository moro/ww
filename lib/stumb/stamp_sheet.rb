require 'haml'
require 'time'

module Stumb
  class StampSheet
    def initialize(stub)
      @stub = stub
      @haml = Haml::Engine.new(<<HAML)
!!!
%html
  %head
  %body
    %h1 Requests
    %table
      - stamps.each do |stamp|
        %tr
          %td&= stamp.time.iso8601
          %td&= stamp.request.ip
          %td&= stamp.request.request_method
          %td&= stamp.request.fullpath
          %td&= stamp.body
HAML
    end

    def call(env)
      [200, {"Content-Type" => "text/html"}, @haml.render(@stub)]
    end
  end
end

