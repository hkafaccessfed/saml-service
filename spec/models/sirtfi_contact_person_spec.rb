# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SIRTFIContactPerson do
  it_behaves_like 'a basic model'

  it { is_expected.to validate_presence(:contact) }
end
