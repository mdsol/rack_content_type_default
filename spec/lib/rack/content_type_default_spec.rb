# frozen_string_literal: true

require 'spec_helper'
require 'rack/mock'

RSpec.describe Rack::ContentTypeDefault do
  let(:app) { ->(env) { [200, { 'Content-Type' => 'text/plain' }, env['PATH_INFO']] } }
  let(:post_req) { Rack::MockRequest.env_for('/api/v2/customers', method: :post) }
  let(:get_req) { Rack::MockRequest.env_for('/api/v2/customers', method: :get) }

  context '/' do
    it 'does not set the content type on default requests' do
      request = Rack::MockRequest.env_for('/')
      request['CONTENT_TYPE'] = 'text/plain'
      Rack::ContentTypeDefault.new(app).call(request)
      expect(request['CONTENT_TYPE']).to eq('text/plain')
    end
  end

  context 'no method explicitly specified applies to post requests only' do
    it 'sets the content type to default application/json' do
      Rack::ContentTypeDefault.new(app).call(post_req)
      expect(post_req['CONTENT_TYPE']).to eq('application/json')
    end

    it 'does not override existing content type' do
      post_req['CONTENT_TYPE'] = 'application/xml'
      Rack::ContentTypeDefault.new(app).call(post_req)
      expect(post_req['CONTENT_TYPE']).to eq('application/xml')
    end

    it 'does override empty content type' do
      post_req['CONTENT_TYPE'] = ''
      Rack::ContentTypeDefault.new(app).call(post_req)
      expect(post_req['CONTENT_TYPE']).to eq('application/json')
    end

    it 'does not override the content type for get request' do
      Rack::ContentTypeDefault.new(app).call(get_req)
      expect(get_req['CONTENT_TYPE']).not_to eq('application/json')
    end
  end

  context 'empty methods specified applies to no requests' do
    it 'does not set content type for any method' do
      Rack::ContentTypeDefault.new(app, []).call(post_req)
      expect(post_req['CONTENT_TYPE']).not_to eq('application/json')
    end
  end

  context 'method' do
    it 'allows to specify the methods' do
      Rack::ContentTypeDefault.new(app, :get).call(get_req)
      Rack::ContentTypeDefault.new(app, :get).call(post_req)
      expect(get_req['CONTENT_TYPE']).to eq('application/json')
      expect(post_req['CONTENT_TYPE']).not_to eq('application/json')
    end

    it 'may be an array' do
      Rack::ContentTypeDefault.new(app, %i[get post]).call(get_req)
      expect(get_req['CONTENT_TYPE']).to eq('application/json')
    end
  end

  context 'content type' do
    it 'allows to specify the content type' do
      Rack::ContentTypeDefault.new(app, :get, 'application/xml').call(get_req)
      expect(get_req['CONTENT_TYPE']).to eq('application/xml')
    end
  end

  context 'paths' do
    it 'sets the content type as appropriate if the path in the request matches one specified' do
      post_req['PATH_INFO'] = 'api/v2/customers/2155/authenticate.json'
      Rack::ContentTypeDefault.new(app, :post, 'application/xml', ['/show', '/authenticate.json']).call(post_req)
      expect(post_req['CONTENT_TYPE']).to eq('application/xml')
    end

    it 'does not set a content type if the path in the request does not match any specified' do
      post_req['PATH_INFO'] = 'api/v2/customers/show'
      Rack::ContentTypeDefault.new(app, %i[get post], 'application/xml', ['/authenticate.json']).call(post_req)
      expect(post_req['CONTENT_TYPE']).to eq(nil)
    end

    it 'sets content type as appropriate on all requests if paths specified as all' do
      Rack::ContentTypeDefault.new(app, :get, 'application/xml', 'all').call(get_req)
      expect(get_req['CONTENT_TYPE']).to eq('application/xml')
    end

    it 'sets content type as appropriate on all requests by default since no paths specified defaults to all paths' do
      Rack::ContentTypeDefault.new(app, :post, 'application/xml').call(post_req)
      expect(post_req['CONTENT_TYPE']).to eq('application/xml')
    end

    it 'does not set content type on any requests if paths specified as empty ' do
      get_req['PATH_INFO'] = 'api/v2/customers/2155/authenticate.json'
      Rack::ContentTypeDefault.new(app, :get, 'application/xml', []).call(get_req)
      expect(get_req['CONTENT_TYPE']).to eq(nil)
    end
  end

  context 'use_path_hint is set to true' do
    it 'overrides content type to application/json if path ends in .json' do
      post_req['PATH_INFO'] = 'api/v2/customers/2155/authenticate.json'
      Rack::ContentTypeDefault.new(app, :post, 'application/xml', ['/authenticate', '/show'], true).call(post_req)
      expect(post_req['CONTENT_TYPE']).to eq('application/json')
    end

    it 'sets content type to application/xml if path ends in .xml' do
      get_req['PATH_INFO'] = 'api/v2/customers/2155/authenticate.xml'
      Rack::ContentTypeDefault.new(app, %i[get post], 'application/xml', 'all', true).call(get_req)
      expect(get_req['CONTENT_TYPE']).to eq('application/xml')
    end

    it 'sets content type to one specified if path does not end in .json or .xml' do
      post_req['PATH_INFO'] = 'api/v2/customers/2155/authenticate.pdf'
      Rack::ContentTypeDefault.new(app, :post, 'application/xml', 'all', true).call(post_req)
      expect(post_req['CONTENT_TYPE']).to eq('application/xml')
    end
  end

  context 'use_path_hint is set to false' do
    it 'does not set content type based on path ending if argument explicitly set to false' do
      get_req['PATH_INFO'] = 'api/v2/customers/2155/authenticate.json'
      Rack::ContentTypeDefault.new(app, :get, 'application/xml', '/authenticate.json', false).call(get_req)
      expect(get_req['CONTENT_TYPE']).to eq('application/xml')
    end

    it 'does not set content type based on path ending if no argument explicitly specified' do
      post_req['PATH_INFO'] = 'api/v2/customers/2155/authenticate.json'
      Rack::ContentTypeDefault.new(app, :post, 'application/xml', '/authenticate.json').call(post_req)
      expect(post_req['CONTENT_TYPE']).to eq('application/xml')
    end
  end
end
