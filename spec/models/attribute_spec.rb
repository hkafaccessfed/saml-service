require 'rails_helper'

describe Attribute do
  it_behaves_like 'a basic model'

  it { is_expected.to validate_presence :name }
  it { is_expected.to have_one_to_one :name_format }
  it { is_expected.to have_one_to_many :attribute_values }
  it { is_expected.to have_many_to_one :idp_sso_descriptor }

  context 'optional attributes' do
    it { is_expected.to have_column :friendly_name }
    it { is_expected.to have_column :legacy_name }
    it { is_expected.to have_column :oid }
    it { is_expected.to have_column :description }
  end

  let(:subject) { create :attribute }
  context 'ownership' do
    it 'must be owned' do
      expect(subject).not_to be_valid
    end

    it 'owned by idp_sso_descriptor' do
      subject.idp_sso_descriptor = create :idp_sso_descriptor
      expect(subject).to be_valid
    end

    it 'owned by attribute_authority_descriptor' do
      subject.attribute_authority_descriptor =
        create :attribute_authority_descriptor

      expect(subject).to be_valid
    end

    it 'cant have multiple owners' do
      subject.idp_sso_descriptor = create :idp_sso_descriptor
      subject.attribute_authority_descriptor =
        create :attribute_authority_descriptor

      expect(subject).not_to be_valid
    end
  end

  describe '#destroy' do
    subject do
      create :attribute, :with_values
    end

    it 'is successfully destroyed' do
      expect { subject.destroy }.not_to raise_error
    end
  end
end
