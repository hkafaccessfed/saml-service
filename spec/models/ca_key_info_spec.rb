require 'rails_helper'

describe CaKeyInfo do
  context 'extends KeyInfo' do
    it { is_expected.to have_many_to_one :entities_descriptor }
  end
end
