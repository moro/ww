require 'ww/application'
require 'thread'

module Ww
  class Server
    class << self
      attr_accessor :app
      attr_accessor :options

      def start_once
        app.reset!
        @current ||= new(app, options).start!
      end
    end

    def initialize(app, options)
      @app = app
      @options = {:handler => :webrick, :port => 3080}.merge(options)
      @handler = ::Rack::Handler.get(@options[:handler])
    end

    def start!
      run_with_picking_server_instance!
      at_exit { shutdown! }
      self
    end

    def shutdown!
      shutdown_http_server
      @thread.kill if @thread.alive?
      self
    end

    private
    def run_with_picking_server_instance!
      q = Queue.new
      @thread = Thread.new { @handler.run(@app, :Port => @options[:port]) {|server| q << server } }
      @server = q.pop
    end

    def shutdown_http_server
      case @server.class.name
      when "WEBrick::HTTPServer" then @server.shutdown
      when "Thin::Server", "Mongrel::HttpServer" then @server.stop
      else
        @server.stop if @server.respond_to? :stop
      end
    end
  end
end
