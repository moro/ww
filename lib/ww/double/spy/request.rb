require 'rack/request'

autoload :JSON, 'json'
autoload :YAML, 'yaml'

module Ww::Double::Spy
  if defined?(ActiveSupport::JSON)
    def decode_json(json_string)
      ActiveSupport::JSON.decode(json_string)
    end
  else
    unless defined?(::JSON)
      begin
        require 'json_pure'
      rescue LoadError
        require 'json'
      end
    end
    def decode_json(json_string)
      ::JSON.parse(json_string)
    end
  end

  module_function :decode_json

  class Request < ::Rack::Request
    attr_reader :time
    @@req_parsers = []

    def self.regist_request_parser(pattern, &block)
      @@req_parsers << [pattern, block]
    end

    regist_request_parser %r{[application|text]/json} do |body|
      ::Ww::Double::Spy.decode_json(body)
    end

    regist_request_parser %r{[application|text]/json} do |body|
      ::Ww::Double::Spy.decode_json(body)
    end

    regist_request_parser %r{[application|text]/yaml} do |body|
      YAML.load(body)
    end

    def initialize(req_or_env)
      env = req_or_env.is_a?(Rack::Request) ? req_or_env.env : req_or_env
      super(env.dup)
      @time = Time.now
    end

    def parsed_body
      return "" if get?
      return self.POST if form_data?

      @body ||=
        begin
          body.read
        ensure
          body.rewind
        end

      _, processor = @@req_parsers.detect{|re, ignore| re =~ media_type }
      processor ? processor.call(@body) : @body
    end
  end
end
