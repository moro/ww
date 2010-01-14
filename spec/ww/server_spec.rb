require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'ww/server'
require 'open-uri'

describe Ww::Server do
  before do
    Ww::Server.options ||= {:handler => :mongrel, :port => 3080 }
    Ww::Server.app ||= Ww::Application.new do
      get("/goodnight") { "Good night" }
      spy(:get, "/hello") { "Hello world" }
    end

    Ww::Server.start_once
    @response = OpenURI.open_uri("http://localhost:3080/hello")
  end

  it do
    URI("http://localhost:3080/hello").read.should == "Hello world"
  end

  it do
    URI("http://localhost:3080/goodnight").read.should == "Good night"
  end

  describe "store only spy-ed action" do
    before do
      URI("http://localhost:3080/goodnight")
      URI("http://localhost:3080/hello")
    end
    it { Ww::Server.app.current.should have(1).requests }
  end

  describe "with stubing" do
    before do
      # validates it's not stubbed.
      URI("http://localhost:3080/goodnight").read.should == "Good night"
      Ww::Server.app.stub(:get, "/goodnight") { "I'm sleepy, too" }
    end

    it do
      URI("http://localhost:3080/goodnight").read.should == "I'm sleepy, too"
    end
  end
end

