# frozen_string_literal: true

require 'rails_helper'

describe NameIdMappingService do
  it { is_expected.to have_many_to_one :idp_sso_descriptor }
end
