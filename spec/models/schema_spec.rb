# frozen_string_literal: true

require 'rails_helper'
require 'gumboot/shared_examples/database_schema'

RSpec.describe 'Database Schema' do
  let(:conn_opts) { Rails.application.config.database_configuration['test'] }
  let(:connection) { Sequel::Model.db.connect(conn_opts) }

  include_context 'Database Schema'
end
