ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'factory_bot_rails'

Shoulda::Context::Context.send(:ruby2_keywords, :method_missing)

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
    include FactoryBot::Syntax::Methods

    # Add more helper methods to be used by all tests here...
  end
end
