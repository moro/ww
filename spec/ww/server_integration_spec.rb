require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'ww/server'
require 'open-uri'
require 'json'

describe Ww::Server do
  before do
    Ww::Server.handler = :webrick
    Ww::Server[:spec] ||= Ww::Server.build_double(3080) do
      get("/goodnight") { "Good night" }
      spy.get("/hello") { "Hello world" }
    end
    Ww::Server.start_once(:spec)
  end

  describe "store only spy-ed action" do
    before do
      ignore = URI("http://localhost:3080/goodnight").read
      ignore = URI("http://localhost:3080/hello").read
    end

    subject { Ww::Server.requests(:spec) }
    it { should have(1).items }
    it { subject.first.path.should == "/hello" }
  end

  describe "spying POST action" do
    before do
      Ww::Server.spy(:spec).post("/message") { status(200) }

      Net::HTTP.start("localhost", 3080) do |http|
        post = Net::HTTP::Post.new("/message")
        post["Content-Type"] = "application/json"
        post.body = {:message => "I'm double Ruby.", :madeby => "moro"}.to_json
        http.request post
      end
    end
    subject { Ww::Server.requests(:spec).first }

    its(:parsed_body) do
      should == {"message" => "I'm double Ruby.", "madeby" => "moro"}
    end
  end

  describe "with stubing" do
    before do
      # validates it's not stubbed.
      URI("http://localhost:3080/goodnight").read.should == "Good night"
      Ww::Server.stub(:spec).get("/goodnight") { "I'm sleepy, too" }
    end

    subject { URI("http://localhost:3080/goodnight").read }
    it { should == "I'm sleepy, too" }
  end

  describe "mocking" do
    before do
      Ww::Server.mock(:spec).get("/goodnight") do
        "OYASUMI-NASAI"
      end
    end

    it "pass if access there" do
      ignore = URI("http://localhost:3080/goodnight").read
      expect{ Ww::Server.verify(:spec) }.should_not raise_error
    end

    it "fail unless access there" do
      expect{ Ww::Server.verify(:spec) }.should raise_error Ww::Double::MockError
    end
  end

  describe "mocking with verifying hash expectation" do
    before do
      Ww::Server.mock(:spec, :key => "value").get("/goodnight") do
        "OYASUMI-NASAI"
      end
    end

    it "fail unless access there" do
      expect{
        URI("http://localhost:3080/goodnight").read
      }.should raise_error Ww::Double::MockError
    end

    it "pass if access there" do
      expect{
        URI("http://localhost:3080/goodnight?key=value").read
      }.should_not raise_error
    end
  end

  describe "mocking with verifying block expectation" do
    before do
      Ww::Server.mock(:spec){|req,par|
        par["key"] == "value"
      }.get("/goodnight") do
        "OYASUMI-NASAI"
      end
    end

    it "fail unless access there" do
      expect{
        URI("http://localhost:3080/goodnight").read
      }.should raise_error Ww::Double::MockError
    end

    it "pass if access there" do
      expect{
        URI("http://localhost:3080/goodnight?key=value").read
      }.should_not raise_error
    end
  end
end

