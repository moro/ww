require File.expand_path("../../spec_helper", File.dirname(__FILE__))
require 'ww/servlet'

describe Ww::Double::Stub, "included to Servlet" do
  before do
    @server = servlet_defining_get_root
  end

  describe "stub(:get, '/dynamic_add')" do
    before do
      @server.stub(:get, '/dynamic_add') do
        response.status = 200
        response["Content-Type"] = "text/plain"
        response.body = "Hi World"
      end
    end

    subject{
      @server.new.call( Rack::MockRequest.env_for("/dynamic_add", :method => "GET"))
    }

    it { should == [200, {"Content-Type"=>"text/plain", "Content-Length"=>"8"}, ["Hi World"]] }
  end

  describe "stub(:get, '/') # override" do
    before do
      @server.stub(:get, '/') do
        response.status = 200
        response["Content-Type"] = "text/plain"
        response.body = "Hi World"
      end
    end

    subject{
      @server.new.call( Rack::MockRequest.env_for("/", :method => "GET"))
    }

    it { should == [200, {"Content-Type"=>"text/plain", "Content-Length"=>"8"}, ["Hi World"]] }
  end

  describe "stub(:get, '/') # re-define after app initialized" do
    before do
      @app = @server.new

      @server.stub(:get, '/') do
        response.status = 200
        response["Content-Type"] = "text/plain"
        response.body = "Hi! World"
      end
    end

    subject{
      @app.call( Rack::MockRequest.env_for("/", :method => "GET"))
    }

    it { should == [200, {"Content-Type"=>"text/plain", "Content-Length"=>"9"}, ["Hi! World"]] }
  end
end

