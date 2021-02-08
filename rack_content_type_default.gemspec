# frozen_string_literal: true

require_relative 'lib/rack/content_type_default/version'

Gem::Specification.new do |s|
  s.name                  = 'rack_content_type_default'
  s.version               = Rack::ContentTypeDefault::VERSION
  s.authors               = ['Purnima Mavinkurve', 'Connor Savage']
  s.email                 = ['pmavinkurve@mdsol.com']
  s.homepage              = 'https://github.com/mdsol/rack_content_type_default'
  s.summary               = 'Rack Middleware for setting content type when not provided'
  s.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  s.require_paths = ['lib']

  s.add_runtime_dependency 'rack'

  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
end
