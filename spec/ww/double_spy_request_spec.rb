require File.expand_path("../spec_helper", File.dirname(__FILE__))

require 'json'
require 'ww/double'
require 'ww/double/spy/request'

describe Ww::Double::Spy::Request do
  describe "GET /" do
    before do
      base = Rack::Request.new(Rack::MockRequest.env_for("/", :method => "GET"))
      @request = Ww::Double::Spy::Request.new(base)
    end

    subject { @request }
    its(:request_method) { should == "GET" }
    its(:parsed_body) { should == "" }
  end

  def post_env(path, content_type, body)
    Rack::MockRequest.env_for(
      path, :method => "POST", :input => body
    ).merge("CONTENT_TYPE" => content_type)
  end

  describe "POST /json_api" do
    before do
      @request = Ww::Double::Spy::Request.new(
        post_env("/json_api", "application/json", JSON.dump({"json" => true}))
      )
    end

    subject { @request }
    its(:request_method) { should == "POST" }
    its(:parsed_body) { should == {"json" => true} }
  end

  describe "POST /yaml_api" do
    before do
      @request = Ww::Double::Spy::Request.new(
        post_env("/yaml_api", "application/yaml", {"yaml" => true}.to_yaml)
      )
    end

    subject { @request }
    its(:parsed_body) { should == {"yaml" => true} }
  end

  describe "POST /www_url_encoded" do
    before do
      body = {"www_url_encoded" => true, "multipart_formdata" => false}.map { |k,v|
        "#{Rack::Utils.escape(k)}=#{Rack::Utils.escape(v)}"
      }.join("&")

      @request = Ww::Double::Spy::Request.new(
        post_env("/post", "application/x-www-form-urlencoded", body)
      )
    end

    subject { @request }
    its(:parsed_body) { should == {"multipart_formdata"=>"false", "www_url_encoded"=>"true"} }
  end

  describe "POST /unkown_type" do
    before do
      @request = Ww::Double::Spy::Request.new(
        post_env("/post", "application/zip", "--not-changed-dummy-string--")
      )
    end

    subject { @request }
    its(:parsed_body) { should == "--not-changed-dummy-string--" }
  end
end

