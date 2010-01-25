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

  describe "SyntaxSuger" do
    describe "stub" do
      before { Ww::Server[:spec].should_receive(:stub).and_return "--stub--" }
      it "Ww::Server.stub(ident) calls Ww::Server[:ident].stub" do
        Ww::Server.stub(:spec).should == "--stub--"
      end

      it "Ww::Server.stub calls Ww::Server[:ident].stub when has only 1 server" do
        Ww::Server.stub.should == "--stub--"
      end
    end

    describe "mock" do
      before { Ww::Server[:spec].should_receive(:mock).with(:key => "value").and_return "--mock--" }

      it "Ww::Server.mock(ident, expectation) calls Ww::Server[:ident].mock(expectation)" do
        Ww::Server.mock(:spec, :key => "value").should == "--mock--"
      end

      it "Ww::Server.mock(expectation) calls Ww::Server[:ident].mock(expectation) when defined only 1 server" do
        Ww::Server.mock(:key => "value").should == "--mock--"
      end
    end

    it "Ww::Server.start_once(ident) calls Ww::Server[:ident].start_once" do
      Ww::Server[:spec].should_receive(:start_once).and_return "--start_once--"
      Ww::Server.start_once(:spec).should == "--start_once--"
    end
  end
end

