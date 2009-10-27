module Stumb
  class Stamp
    attr_reader :time, :request
    def initialize(req)
      @time = Time.now
      @request  = req
    end

    def body
      return @body if @body
      begin
        @body ||= @request.body.read
      ensure
        @request.body.rewind
      end
    end
  end
end
