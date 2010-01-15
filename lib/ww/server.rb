require 'thread'
require 'forwardable'
require 'ww/double'

module Ww
  autoload :Application, 'ww/application'
  class Server
    extend Forwardable
    @@servers = {}
    @@handler = :webrick

    class << self
      def servers; @@servers; end

      def handler; @@handler; end
      def handler=(v); @@handler = v; end

      def [](name); @@servers[name] ; end
      def []=(name, server); @@servers[name] = server ; end

      def build_double(port, &block)
        new(Application.new(&block), port)
      end
    end

    def_delegators :current_app, *double_methods = %w[
      spy requests mock verify stub
    ]

    attr_reader :app

    def initialize(app, port)
      @app = app
      @port = port
      @handler = ::Rack::Handler.get(self.class.handler)
    end

    def start_once
      @app.reset!
      start! unless running?
    end

    def running?; !!@running ; end

    def start!
      run_with_picking_server_instance!
      @running = true
      at_exit { shutdown! }
      self
    end

    def shutdown!
      return unless @running
      shutdown_http_server
      @thread.kill if @thread.alive?
      @running = false
      self
    end

    private
    def run_with_picking_server_instance!
      q = Queue.new
      @thread = Thread.new { @handler.run(@app, :Port => @port) {|server| q << server } }
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

    def current_app
      app.current
    end
  end
end
