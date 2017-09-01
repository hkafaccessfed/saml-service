# frozen_string_literal: true

require 'rails_helper'

describe OrganizationName do
  context 'Extends LocalizedName' do
    it { is_expected.to validate_presence :organization }
  end
end
