# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'rack/content_type_default'
require 'rspec'

RSpec.configure do |config|
  config.disable_monkey_patching!

  Kernel.srand config.seed
end
