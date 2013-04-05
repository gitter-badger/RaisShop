require 'simplecov'
SimpleCov.start 'rails'
#require 'coveralls'
#Coveralls.wear!('rails')
require 'rubygems'

ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara.javascript_driver = :webkit
#Capybara.javascript_driver = :selenium

RSpec.configure do |config|

  config.filter_run_excluding broken: true
  config.mock_with :rspec
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL
  config.include Devise::TestHelpers, type: :controller
end
