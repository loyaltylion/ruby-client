require 'loyaltylion'
require 'webmock/rspec'

RSpec.configure do |rspec|
  rspec.color = true
  rspec.tty = true
  rspec.order = 'random'
  rspec.backtrace_exclusion_patterns << /gems/

  rspec.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  rspec.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
