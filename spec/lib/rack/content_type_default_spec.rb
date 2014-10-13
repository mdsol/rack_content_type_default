require 'spec_helper'
require 'rack/mock'

describe Rack::ContentTypeDefault do
  App = lambda { |env| [200, {'Content-Type' => 'text/plain'}, env['PATH_INFO']] }

  context '/' do
    it 'does not set the content type on default requests' do
      request  = Rack::MockRequest.env_for("/")
      request['CONTENT_TYPE'] = 'text/plain'
      Rack::ContentTypeDefault.new(App).call(request)
      request['CONTENT_TYPE'].should == 'text/plain'
    end
  end

  context 'no method explicitly specified applies to post requests only' do
    it 'sets the content type to default application/json' do
      request  = Rack::MockRequest.env_for("/api/v2/customers", method: :post)
      Rack::ContentTypeDefault.new(App).call(request)
      request['CONTENT_TYPE'].should == 'application/json'
    end

    it 'does not override existing content type' do
      request  = Rack::MockRequest.env_for("/api/v2/customers", method: :post)
      request['CONTENT_TYPE'] = 'application/xml'
      Rack::ContentTypeDefault.new(App).call(request)
      request['CONTENT_TYPE'].should == 'application/xml'
    end

    it 'does override empty content type' do
      request  = Rack::MockRequest.env_for("/api/v2/customers", method: :post)
      request['CONTENT_TYPE'] = ''
      Rack::ContentTypeDefault.new(App).call(request)
      request['CONTENT_TYPE'].should == 'application/json'
    end

    it 'does not the content type for get request' do
      request  = Rack::MockRequest.env_for("/api/v2/customers", method: :get)
      Rack::ContentTypeDefault.new(App).call(request)
      request['CONTENT_TYPE'].should_not == 'application/json'
    end
  end

  context 'empty methods specified applies to no requests' do
    it 'does not set content type for any method' do
      request  = Rack::MockRequest.env_for("/api/v2/customers", method: :post)
      Rack::ContentTypeDefault.new(App, []).call(request)
      request['CONTENT_TYPE'].should_not == 'application/json'
    end
  end

  context 'method' do
    it 'allows to specify the methods' do
      request1  = Rack::MockRequest.env_for("/api/v2/customers", method: :get)
      request2  = Rack::MockRequest.env_for("/api/v2/customers/1", method: :post)
      Rack::ContentTypeDefault.new(App, :get).call(request1)
      Rack::ContentTypeDefault.new(App, :get).call(request2)
      request1['CONTENT_TYPE'].should == 'application/json'
      request2['CONTENT_TYPE'].should_not == 'application/json'
    end

    it 'may be an array' do
      request  = Rack::MockRequest.env_for("/api/v2/customers", method: :get)
      Rack::ContentTypeDefault.new(App, [:get, :post]).call(request)
      request['CONTENT_TYPE'].should == 'application/json'
    end
  end

  context 'content type' do
    it 'allows to specify the content type' do
      request  = Rack::MockRequest.env_for("/api/v2/customers", method: :get)
      Rack::ContentTypeDefault.new(App, :get, 'application/xml').call(request)
      request['CONTENT_TYPE'].should == 'application/xml'
    end
  end
end

