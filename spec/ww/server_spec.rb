require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'ww/server'
require 'open-uri'
require 'json'

describe Ww::Server do
  before do
    Ww::Server.handler = :mongrel # Mongrel is most silent.
    Ww::Server[:spec] ||= Ww::Server.build_double(3080) do
      get("/goodnight") { "Good night" }
      spy.get("/hello") { "Hello world" }
    end
    Ww::Server[:spec].start_once
  end
  subject { Ww::Server[:spec] }
  it { should be_running }
  it "should works fine" do
    URI("http://localhost:3080/hello").read.should == "Hello world"
    URI("http://localhost:3080/goodnight").read.should == "Good night"
  end
  its(:port){ should == 3080 }

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

end

