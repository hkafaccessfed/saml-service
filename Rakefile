# frozen_string_literal: true

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

begin
  require 'rubocop/rake_task'
  require 'brakeman'

  RuboCop::RakeTask.new

  task :brakeman do
    Brakeman.run app_path: '.', print_report: true, exit_on_warn: true
  end

  task default: %i[rubocop spec brakeman]
rescue LoadError
  task default: []
end

task spec: :'xsd:all'
