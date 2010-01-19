require File.expand_path("../../spec_helper", File.dirname(__FILE__))
require 'ww/servlet'

describe Ww::Double, "with Servlet" do
  before do
    @server = servlet_defining_get_root
  end

  describe "spy(:get, '/')" do
    before do
      @server.spy(:get, '/') do
        response.status = 200
        response["Content-Type"] = "text/plain"
        response.body = "Hi World"
      end
    end

    describe "GET / リクエストの" do
      before do
        app = @server.new
        @response = app.call( Rack::MockRequest.env_for("/", :method => "GET"))
      end

      subject{ @server.requests.first }

      it { should be_a Rack::Request }
      its(:request_method) { should == 'GET' }
      its(:fullpath) { should == "/" }

      it "bodyは空のIOであること" do
        subject.body.rewind
        subject.body.read.should == ""
      end

      it "レスポンスは想定どおりのものであること" do
        @response.should ==
          [200, {"Content-Type"=>"text/plain", "Content-Length"=>"8"}, ["Hi World"]]
      end
    end
  end

  describe "spy(:get, '/') backword compat, old version spy! or spy(:get..) called stump!" do
    before do
      @server.get('/backword') do
        stump!

        response.status = 200
        response["Content-Type"] = "text/plain"
        response.body = "Hi World"
      end

      app = @server.new
      @response = app.call( Rack::MockRequest.env_for("/backword", :method => "GET"))
    end

    subject{ @server.requests }
    it { should_not be_empty }
    it { @server.requests.first.should be_a Ww::Double::Spy::Request }
  end

  describe "spy_them_all! - extend spy feature to all actions" do
    before do
      @server.spy_them_all!
      app = @server.new
      3.times{ app.call( Rack::MockRequest.env_for("/", :method => "GET")) }
    end
    subject{ @server }

    it { should have(3).requests }
  end
end

