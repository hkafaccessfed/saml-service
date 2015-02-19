require 'rubocop/rake_task'
require 'brakeman'
require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks
RuboCop::RakeTask.new

task :brakeman do
  Brakeman.run app_path: '.', print_report: true, exit_on_warn: true
end

task default: [:rubocop, :spec, :brakeman]

task spec: :'xsd:all'
