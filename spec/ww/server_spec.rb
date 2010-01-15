require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'ww/server'
require 'open-uri'
require 'json'

describe Ww::Server do
  before do
    Ww::Server.handler = :mongrel # Mongrel is most silent.
    Ww::Server[:spec] ||= Ww::Server.build_double(3080) do
      get("/goodnight") { "Good night" }
      spy(:get, "/hello") { "Hello world" }
    end
    Ww::Server[:spec].start_once
  end
  subject { Ww::Server[:spec] }
  it { should be_running }

  describe "shutdown!" do
    before do
      # mongrel fails to shutdon before accepting any req.
      URI("http://localhost:3080/hello").read
      Ww::Server[:spec].shutdown!
    end

    it { should_not be_running }

    it "the server should be down" do
      expect { URI("http://localhost:3080/hello").read }.should \
        raise_error Errno::ECONNREFUSED
    end
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

    subject { Ww::Server[:spec].requests }
    it { should have(1).items }
    it { subject.first.path.should == "/hello" }
  end

  describe "spying POST action" do
    before do
      Ww::Server[:spec].spy(:post, "/message") { status(200) }

      Net::HTTP.start("localhost", 3080) do |http|
        post = Net::HTTP::Post.new("/message")
        post["Content-Type"] = "application/json"
        post.body = {:message => "I'm double Ruby.", :madeby => "moro"}.to_json
        http.request post
      end
    end
    subject { Ww::Server[:spec].requests.first }

    its(:parsed_body) do
      should == {"message" => "I'm double Ruby.", "madeby" => "moro"}
    end
  end

  describe "with stubing" do
    before do
      # validates it's not stubbed.
      URI("http://localhost:3080/goodnight").read.should == "Good night"
      Ww::Server[:spec].stub(:get, "/goodnight") { "I'm sleepy, too" }
    end

    subject { URI("http://localhost:3080/goodnight").read }
    it { should == "I'm sleepy, too" }
  end
end

