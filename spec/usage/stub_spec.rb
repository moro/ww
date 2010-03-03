require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'ww/server'
require 'open-uri'

describe "Ww::Server.stub learning" do
  before(:all) do
    @@stub_server ||= Ww::Server.build_double(3081) do
      stub.get("/hello") { "Hello World." }
    end

    @@stub_server.start_once
  end

  it "get greeting message" do
    URI("http://localhost:3081/hello").read.strip.should == "Hello World."
  end

  context "overwride stub w/ japanese one" do
    before do
      @@stub_server.stub.get("/hello") { "Kon-nichiwa Sekai" }
    end

    it "get greeting message in Japanese" do
      URI("http://localhost:3081/hello").read.strip.should == "Kon-nichiwa Sekai"
    end
  end
end
