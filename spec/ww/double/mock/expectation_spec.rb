require File.expand_path("../../../spec_helper", File.dirname(__FILE__))
require 'ww/double'
require 'ww/double/mock/expectation'
require 'rack/mock'

describe Ww::Double::Mock::Expectation do
  before do
    @request = Rack::Request.new( Rack::MockRequest.env_for("/pass?key=value", :method => "GET"))
  end
  subject { expect{ @expectation.verify(@request, Thread.current) } }

  describe "with block" do
    before do
      v = lambda {|req, p| req.path == "/pass" }
      @expectation = Ww::Double::Mock::Expectation.new(:get, "/", v)
    end
    it { should_not raise_error Exception }

    describe "fail" do
      before do
        v = lambda {|req, p| req.path == "/fail" }
        @expectation = Ww::Double::Mock::Expectation.new(:get, "/", v)
      end
      it { should raise_error Ww::Double::MockError }
    end
  end

  describe "with hash w/ String match" do
    before do
      @expectation = Ww::Double::Mock::Expectation.new(:get, "/", :key => "value")
    end
    it { should_not raise_error Exception }

    describe "fail" do
      before do
        @expectation = Ww::Double::Mock::Expectation.new(:get, "/", :key => "VALUE")
      end
      it { should raise_error Ww::Double::MockError }
    end

    describe "regexp" do
      before do
        @expectation = Ww::Double::Mock::Expectation.new(:get, "/", :key => /VALUE/i)
      end
      it { should_not raise_error Exception }
    end
  end
end

