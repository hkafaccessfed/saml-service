require 'rails_helper'

RSpec.describe MDUI::DiscoHints, type: :model do
  it_behaves_like 'a basic model'

  context 'optional attributes' do
    it { is_expected.to have_one_to_many :ip_hints }
    it { is_expected.to have_one_to_many :domain_hints }
    it { is_expected.to have_one_to_many :geolocation_hints }
  end

  describe '#destroy' do
    subject do
      create :mdui_disco_hints_with_content
    end

    it 'is successfully destroyed' do
      expect { subject.destroy }.not_to raise_error
    end
  end
end
