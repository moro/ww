require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'ww/server'
require 'open-uri'
require 'json'

describe Ww::Server do
  before do
    Ww::Server.options ||= {:handler => :mongrel, :port => 3080 }
    Ww::Server.app ||= Ww::Application.new do
      get("/goodnight") { "Good night" }
      spy(:get, "/hello") { "Hello world" }
    end

    Ww::Server.start_once
  end

  it do
    URI("http://localhost:3080/hello").read.should == "Hello world"
  end

  it do
    URI("http://localhost:3080/goodnight").read.should == "Good night"
  end

  describe "store only spy-ed action" do
    before do
      ignore = URI("http://localhost:3080/goodnight").read
      ignore = URI("http://localhost:3080/hello").read
    end

    subject { Ww::Server.app.current.requests }
    it { should have(1).items }
    it { subject.first.path.should == "/hello" }
  end

  describe "spying POST action" do
    before do
      Ww::Server.app.spy(:post, "/message") { status(200) }

      Net::HTTP.start("localhost", 3080) do |http|
        post = Net::HTTP::Post.new("/message")
        post["Content-Type"] = "application/json"
        post.body = {:message => "I'm double Ruby.", :madeby => "moro"}.to_json
        http.request post
      end
    end
    subject { Ww::Server.app.current.requests.first }

    its(:parsed_body) do
      should == {"message" => "I'm double Ruby.", "madeby" => "moro"}
    end
  end

  describe "with stubing" do
    before do
      # validates it's not stubbed.
      URI("http://localhost:3080/goodnight").read.should == "Good night"
      Ww::Server.app.stub(:get, "/goodnight") { "I'm sleepy, too" }
    end

    subject { URI("http://localhost:3080/goodnight").read }
    it { should == "I'm sleepy, too" }
  end
end

