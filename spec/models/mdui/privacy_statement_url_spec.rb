# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MDUI::PrivacyStatementURL, type: :model do
  context 'Extends LocalizedURI' do
    it { is_expected.to have_many_to_one :ui_info }
    it { is_expected.to validate_presence :ui_info }
  end
end
