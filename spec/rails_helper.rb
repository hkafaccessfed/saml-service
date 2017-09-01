# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require 'factory_girl_rails'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rails'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

Timecop.safe_mode = true

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryGirl::Syntax::Methods
  config.include Rails.application.routes.url_helpers

  # Use Sequel matchers and transactions
  config.include RspecSequel::Matchers
  config.around(:each) do |spec|
    Sequel::Model.db.transaction(rollback: :always,
                                 auto_savepoint: true) { spec.run }
  end

  config.around(:each, :debug) do |spec|
    begin
      logger = Logger.new($stderr)
      Sequel::Model.db.loggers << logger
      spec.run
    ensure
      Sequel::Model.db.loggers.delete(logger)
    end
  end

  config.infer_spec_type_from_file_location!
end
