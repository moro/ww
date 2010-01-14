require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'ww/servlet'

describe Ww::Servlet do
  before do
    @server = Ww::Servlet.base do
      get("/") do
        response.status = 200
        response["Content-Type"] = "text/plain"
        response.body = "Hello World"
      end
    end
  end
  subject{ @server }
  it { should be_instance_of Class }

  describe "GET /" do
    subject do
      @server.new.call( Rack::MockRequest.env_for("/", :method => "GET"))
    end

    it { should == [200, {"Content-Type"=>"text/plain", "Content-Length"=>"11"}, ["Hello World"]] }
  end
end
