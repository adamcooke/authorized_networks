$:.unshift(File.expand_path('../../lib', __FILE__))
require 'authorized_networks'

AuthorizedNetworks.configure do |config|
  config.networks_file_path = File.expand_path('../networks.yml', __FILE__)
end

RSpec.configure do |config|
  config.color = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
