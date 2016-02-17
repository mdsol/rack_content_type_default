lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rack/content_type_default/version'

Gem::Specification.new do |s|
  s.name                      = 'rack_content_type_default'
  s.version                   = Rack::ContentTypeDefault::VERSION
  s.authors                   = ['Purnima Mavinkurve', 'Connor Savage']
  s.email                     = ['pmavinkurve@mdsol.com', 'csavage@mdsol.com']
  s.homepage                  = 'https://github.com/pmavinkurve-mdsol/rack_content_type_default'
  s.summary                   = 'Rack Middleware for setting content type when not provided' 
  s.description               = 'Rack Middleware for setting content type when not provided'

  s.required_rubygems_version = ">= 1.3.5"

  s.files                     = Dir.glob("{lib}/**/*")
  s.require_path              = 'lib'

  s.add_runtime_dependency 'rack'

  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rspec'
  s.add_development_dependency('debugger', '~> 1.6.0')
  s.add_development_dependency('simplecov')
end
