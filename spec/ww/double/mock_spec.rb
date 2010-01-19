require File.expand_path("../../spec_helper", File.dirname(__FILE__))
require 'ww/servlet'

describe Ww::Double::Mock, "with Servlet" do
  before do
    @server = servlet_defining_get_root
  end

  describe "mock(:get, '/', :verify => lambda" do
    before do
      v = Proc.new {|req, par| par["entity_id"].to_i == 1 && par["entity_value"] == "var" }

      @server.mock( :get, '/', :verify => v) do
        response.status = 200
        response["Content-Type"] = "text/plain"
        response.body = "Hi World"
      end
      @server.testing_thread = Thread.new{ sleep }
    end

    it do
      @server.new.call( Rack::MockRequest.env_for("/", :method => "GET"))
      @server.testing_thread.should_not be_alive
    end

    it do
      @server.new.call( Rack::MockRequest.env_for("/?entity_id=1&entity_value=var", :method => "GET"))
      @server.testing_thread.should be_alive
    end
  end

  describe "mock(:get, '/')" do
    before do
      @server.mock(:get, '/') do
        response.status = 200
        response["Content-Type"] = "text/plain"
        response.body = "Hi World"
      end
    end

    describe "call" do
      before do
        app = @server.new
        @response = app.call( Rack::MockRequest.env_for("/", :method => "GET"))
      end

      subject{ @response }

      it { should == [200, {"Content-Type"=>"text/plain", "Content-Length"=>"8"}, ["Hi World"]] }
      it {
        expect{ @server.verify }.should_not raise_error Ww::Double::MockError
      }
    end

    describe "don't call" do
      it { expect{ @server.verify }.should raise_error Ww::Double::MockError }
    end
  end
end

