if ENV['coverage']
  require 'simplecov'
  SimpleCov.start 'rails'
  require 'coveralls'
  Coveralls.wear!('rails')
end
require 'rubygems'

ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require "rack_session_access/capybara"
require 'capybara/poltergeist'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

#Capybara.javascript_driver = :webkit
Capybara.javascript_driver = :poltergeist
#Capybara.javascript_driver = :selenium

Mongoid.logger = nil
Moped.logger = nil

RSpec.configure do |config|

  config.include Mongoid::Matchers
  config.filter_run_excluding broken: true
  config.mock_with :rspec
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before(:each) do
    Mongoid.default_session.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end

  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL
  config.include Devise::TestHelpers, type: :controller

  config.before(:all) do
      DeferredGarbageCollection.start
  end

  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end
end
