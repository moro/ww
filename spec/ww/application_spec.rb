require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'ww/application'

describe Ww::Application do
  before do
    @container = Ww::Application.new do
      get("/hello") do
        "Hello World"
      end
    end

    @client = Rack::MockRequest.new(@container)
  end
  subject { @client.get("/hello") }

  describe "GET /hello" do
    its(:status) { should == 200 }
    its(:body) { should == "Hello World" }
  end

  describe "GET /hello (stubbed)" do
    before do
      @container.current.stub.get("/hello") { response = "Good night" }
    end
    its(:body) { should == "Good night" }

    describe "refleshed" do
      before do
        @container.reset!
      end

      its(:body) { should == "Hello World" }
    end
  end
end
