require File.expand_path("../../spec_helper", File.dirname(__FILE__))
require 'ww/servlet'

describe Ww::Double, "with Servlet" do
  before do
    @server = servlet_defining_get_root
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

