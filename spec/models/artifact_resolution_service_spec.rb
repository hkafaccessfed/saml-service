# frozen_string_literal: true

require 'rails_helper'

describe ArtifactResolutionService do
  it { is_expected.to have_many_to_one :sso_descriptor }

  context 'validations' do
    it { is_expected.to validate_presence :sso_descriptor }
  end
end
