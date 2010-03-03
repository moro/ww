require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'ww/server'
require 'open-uri'

describe "Ww::Server.spy learning" do
  before(:all) do
    @@spy_server ||= Ww::Server.build_double(3082) do
      spy.get("/hello") { "Hello World." }
    end
    @@spy_server.start_once
  end

  context "GET /hello" do
    before do
      @respose = URI("http://localhost:3082/hello").read
    end

    it "the server should requesed to /hello" do
      req = @@spy_server.requests.first

      req.path.should == "/hello"
    end

    it "get greeting message" do
      @respose.strip.should == "Hello World."
    end
  end

  context "POST /greet" do
    before do
      # can define outside of block
      @@spy_server.spy.post("/greet") { status(200) }

      # POST from other process, ok it's fully functional server.
      system("curl -s -o /dev/null -d lang=ja -d message=konnichiwa http://localhost:3082/greet")
    end
    subject{ @@spy_server.requests.first }

    its(:request_method){ should == "POST" }
    its(:parsed_body){ should == {"lang" => "ja", "message" => "konnichiwa" } }
  end
end

