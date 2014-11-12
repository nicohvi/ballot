ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'spec_helper'
require 'simplecov'
require 'capybara-webkit'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.include FactoryGirl::Syntax::Methods
  config.infer_spec_type_from_file_location!
  
  # Custom helpers
  
  # Database management
  config.before(:suite) do
    begin
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean_with :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  # Specific instructions for capybara specs as the browser
  # operates in a separate thread.
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  
  Capybara.javascript_driver = :webkit
  Capybara.raise_server_errors = false # Avoid failed specs due to 404s
 
end
