# This is a simple Rack Middleware to set the request content type for specific routes. It checks if a content type is
# set and does not override the existing one. The options allow you to specify the request methods and the content type
# to be set. The options also allow you to set a default content type only on select paths. In addition, the options
# allow  you to set content type to to application/json or application/xml if possible based on the path ending.
# Copied and adapted from https://gist.github.com/tstachl/6264249
module Rack
  class ContentTypeDefault
    def initialize(app, methods = [:post], content_type = 'application/json', paths = 'all', use_path_hint = false)
      @app = app
      @methods = [*methods].map{ |item| item.to_s.upcase }
      @content_type = content_type
      @paths = [*paths]
      @use_path_hint = use_path_hint
    end

    def call(env)
      req = Rack::Request.new(env)
      if override_content_type?(req)
        env['CONTENT_TYPE'] = @use_path_hint ? determine_content_type(req.env['PATH_INFO']) :  @content_type
      end
      @app.call(env)
    end

    private
    # Determine whether or not to override content type
    def override_content_type?(req)
      (req.content_type.nil? || req.content_type.empty?) && match_method?(req.request_method) &&
          match_path?(req.env['PATH_INFO'])
    end

    # Match the method on the request with the methods specified or the default.
    # If @methods was provided as empty, content type will not be set.
    def match_method?(method)
      @methods.include?(method)
    end

    # Match the path on the request with the paths specified. Content type is set only if a match is found.
    # If @paths was provided with 'all' as the first element (default), content type will be set for all requests.
    # If @paths was explicitly set to empty, content type will not be set.
    def match_path?(filter)
      @paths.first == 'all' || @paths.any? { |path| /#{path}$/.match(filter) || /#{path}\./.match(filter) }
    end

    #Determine if content type can be set to application/json or application/xml based on the path ending.
    #If the path does not end in xml or json, content type is set to the given default.
    def determine_content_type(path_info)
      inferred = path_info.split('.').last
      inferred == 'json' || inferred == 'xml' ? "application/#{inferred}" : @content_type
    end
  end
end
