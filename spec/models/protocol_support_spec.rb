# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProtocolSupport, type: :model do
  context 'Extends SamlURI' do
    context 'validations' do
      it { is_expected.to have_many_to_one :role_descriptor }
      it { is_expected.to validate_presence :role_descriptor }
    end
  end
end
