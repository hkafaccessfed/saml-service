# frozen_string_literal: true

shared_examples 'a basic model' do
  it { is_expected.to validate_presence :created_at }
  it { is_expected.to validate_presence :updated_at }
end
