# This is a simple Rack Middleware to set the request content type for specific routes. It checks if a content type is
# set and does not override the existing one. The options allow you to specify the request methods, and the content type
# to be set.
# Copied and adapted from https://gist.github.com/tstachl/6264249

module Rack
  class ContentTypeDefault
    def initialize(app, methods = [:get], content_type = 'application/json')
      @app = app
      @methods = [*methods].map{ |item| item.to_s.upcase }
      @content_type = content_type
    end

    def call(env)
      req = Rack::Request.new(env)

      if match_method?(req.request_method)
        env['CONTENT_TYPE'] = @content_type if req.content_type.nil? or req.content_type.empty?
      end

      @app.call(env)
    end

    private
    # Match the method on the request with the methods specified or the default.
    # If @methods was provided as empty content type will not be set.
    def match_method?(method)
      @methods.include?(method)
    end
  end
end

