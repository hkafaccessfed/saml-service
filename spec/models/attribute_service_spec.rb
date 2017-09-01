# frozen_string_literal: true

require 'rails_helper'

describe AttributeService do
  it { is_expected.to validate_presence :attribute_authority_descriptor }
end
