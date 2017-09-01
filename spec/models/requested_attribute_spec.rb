# frozen_string_literal: true

require 'rails_helper'

describe RequestedAttribute do
  context 'extends Attribute' do
    it { is_expected.to validate_presence :reasoning }
    it { is_expected.to validate_presence :required }
  end
end
