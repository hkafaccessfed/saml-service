# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MDRPI::UsagePolicy, type: :model do
  context 'Extends LocalizedName' do
    it { is_expected.to have_many_to_one :publication_info }
    it { is_expected.to validate_presence :publication_info }
  end
end
