require 'rails_helper'

RSpec.describe MDUI::UIInfo, type: :model do
  it_behaves_like 'a basic model'

  it { is_expected.to have_many_to_one :role_descriptor }
  it { is_expected.to validate_presence :role_descriptor }

  context 'validations' do
    context 'instance validations' do
      subject { create :mdui_ui_info }
      it { is_expected.to validate_presence :display_names }
      it { is_expected.to validate_presence :descriptions }
    end
  end

  context 'optional attributes' do
    it { is_expected.to have_one_to_many :keyword_lists }
    it { is_expected.to have_one_to_many :logos }
    it { is_expected.to have_one_to_many :information_urls }
    it { is_expected.to have_one_to_many :privacy_statement_urls }
  end

  describe '#destroy' do
    subject do
      create :mdui_ui_info, :with_multiple_display_names,
             :with_multiple_descriptions, :with_content
    end

    it 'is successfully destroyed' do
      expect { subject.destroy }.not_to raise_error
    end
  end
end
