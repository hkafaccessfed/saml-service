# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MDRPI::PublicationInfo, type: :model do
  it_behaves_like 'a basic model'

  it { is_expected.to have_many_to_one :metadata_instance }
  it { is_expected.to have_many_to_one :entity_descriptor }
  it { is_expected.to have_one_to_many :usage_policies }

  it { is_expected.to validate_presence :publisher }

  context 'usage policies' do
    let(:subject) { create :mdrpi_publication_info }
    it { is_expected.to validate_presence :usage_policies }
  end

  context 'ownership' do
    let(:subject) { create :mdrpi_publication_info }

    it 'must be owned' do
      expect(subject).not_to be_valid
    end

    it 'owned by metadata_instance' do
      subject.reload
      subject.metadata_instance = create :metadata_instance
      expect(subject).to be_valid
    end

    it 'owned by entity_descriptor' do
      subject.entity_descriptor = create :entity_descriptor
      expect(subject).to be_valid
    end

    it 'cant have multiple owners' do
      subject.metadata_instance = create :metadata_instance
      subject.entity_descriptor = create :entity_descriptor

      expect(subject).not_to be_valid
    end
  end

  describe '#destroy' do
    subject do
      create :mdrpi_publication_info
    end

    it 'is successfully destroyed' do
      expect { subject.destroy }.not_to raise_error
    end
  end
end
