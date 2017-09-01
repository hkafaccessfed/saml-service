# frozen_string_literal: true

require 'rails_helper'

describe AttributeValue do
  it_behaves_like 'a basic model'

  it { is_expected.to validate_presence :attribute }
  it { is_expected.to validate_presence :value }
end
