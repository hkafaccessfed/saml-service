# frozen_string_literal: true

require 'rails_helper'

describe SingleLogoutService do
  it { is_expected.to have_many_to_one :sso_descriptor }
end
