# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MDRPI::RegistrationPolicy, type: :model do
  context 'Extends LocalizedName' do
    it { is_expected.to have_many_to_one :registration_info }
    it { is_expected.to validate_presence :registration_info }
  end
end
