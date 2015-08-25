$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lateral'

unless ENV['COVERAGE'] == 'false'
  require 'simplecov'
  SimpleCov.start do
    minimum_coverage 99
    add_filter '/vendor/'
    add_filter '/spec/'
  end
end

require 'webmock/rspec'
require 'rspec/its'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

Lateral.configure do |config|
  config.api_key = 'dummy-api-key'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.filter_run_excluding disabled: true
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  # config.warnings          = true
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.profile_examples  = 10

  config.order = :random
  Kernel.srand config.seed
end
