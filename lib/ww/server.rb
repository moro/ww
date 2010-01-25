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

      def detect_server(args)
        if servers.include?(args.first)
          return self[args.shift]
        elsif servers.size == 1
          return servers.values.first
        end
        raise ArgumentError, "Ambigous server" unless server
      end
    end

    double_methods = %w[
      spy spy_them_all! requests
      mock verify
      stub
    ]

    # server instance delegate the methods to currently working Ww::Servlet
    def_delegators :current_servlet, *double_methods

    # syntax sugers above
    (double_methods + %w[start_once shutdown running?]).each do |server_method|
      class_eval <<-RUBY, __FILE__, __LINE__
      def self.#{server_method}(*args, &block)
        detect_server(args).#{server_method}(*args, &block)
      end
      RUBY
    end

    attr_reader :app, :port

    def initialize(app, port)
      @app = app
      @port = port
      @handler = ::Rack::Handler.get(self.class.handler)
    end

    def start_once
      @app.reset!
      current_servlet.testing_thread = Thread.current
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
      opt = handler_options(@handler)
      @thread = Thread.new { @handler.run(@app, opt ) {|server| q << silence!(server) } }
      @server = q.pop
    end

    def handler_options(handler)
      opt = {:Port => @port}
      if handler.name == "Rack::Handler::WEBrick"
        l = WEBrick::Log.new("/dev/null")
        opt.update(:Logger => l, :AccessLog => [l, WEBrick::AccessLog::COMMON_LOG_FORMAT])
      end
      return opt
    end

    def silence!(server)
      case server.class.name
      when "Thin::Server" then server.silent = true
      end
      return server
    end

    def shutdown_http_server
      case @server.class.name
      when "WEBrick::HTTPServer" then @server.shutdown
      when "Thin::Server", "Mongrel::HttpServer" then @server.stop
      else
        @server.stop if @server.respond_to? :stop
      end
    end

    def current_servlet
      app.current
    end
  end
end
