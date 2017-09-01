# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NameFormat, type: :model do
  context 'Extends SamlURI' do
    it { is_expected.to have_many_to_one :attribute }
  end
end
