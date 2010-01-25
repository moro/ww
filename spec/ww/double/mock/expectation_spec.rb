require File.expand_path("../../../spec_helper", File.dirname(__FILE__))
require 'ww/double'
require 'ww/double/mock/expectation'
require 'rack/mock'

describe Ww::Double::Mock::Expectation, "[GET] /pass?key=value&int=10" do
  def expectation(*verifier, &block)
    Ww::Double::Mock::Expectation.new(:get, "/pass", *verifier, &block)
  end

  before do
    @request = Rack::Request.new( Rack::MockRequest.env_for("/pass?key=value&int=10", :method => "GET"))
  end
  subject { expect{ @expectation.verify(@request, Thread.current) } }

  describe "with block" do
    before do
      @expectation = expectation{|req, prm|
        req.path == "/pass" &&
        prm["key"] == "value" &&
        prm["int"] == "10"
      }
    end
    it { should_not raise_error Exception }

    describe "fail" do
      before do
        @expectation = expectation{|req, prm|
          req.path == "/pass" &&
          prm["key"] == "value" &&
          prm["int"] == "11"
        }
      end
      it { should raise_error Ww::Double::MockError }
    end
  end

  describe ":key => \"value\"" do
    before { @expectation = expectation(:key => "value") }
    it { should_not raise_error Exception }

    describe ":key => \"VALUE\"" do
      before { @expectation = expectation(:key => "VALUE") }
      it { should raise_error Ww::Double::MockError }
    end
  end

  describe ":key => /VALUE/i # regexp match" do
    before { @expectation = expectation(:key => /VALUE/i) }
    it { should_not raise_error Exception }
  end

  describe ":int => 10" do
    before { @expectation = expectation(:int => 10) }
    it { should_not raise_error Exception }
  end

  describe ":int => Integer" do
    before { @expectation = expectation(:int => Integer) }
    it { should_not raise_error Exception }
  end

  describe ":header => {:path_info => \"pass\"}" do
    before { @expectation = expectation(:header => {:path_info => "/pass"}) }
    it { should_not raise_error Exception }

    describe ":key => \"VALUE\"" do
      before { @expectation = expectation(:header => {:path_info => "/fail"}) }
      it { should raise_error Ww::Double::MockError }
    end
  end
end

