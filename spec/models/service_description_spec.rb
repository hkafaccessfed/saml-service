# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceDescription, type: :model do
  context 'extends LocalizedName' do
    it { is_expected.to validate_presence :attribute_consuming_service }
  end
end
