# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MDATTR::EntityAttribute, type: :model do
  it_behaves_like 'a basic model'

  it { is_expected.to have_many_to_one :metadata_instance }
  it { is_expected.to have_many_to_one :entity_descriptor }
  it { is_expected.to have_one_to_many :attributes }

  context 'validations' do
    let(:subject) { create :mdattr_entity_attribute }

    context 'ownership' do
      it 'must be owned' do
        expect(subject).not_to be_valid
      end

      it 'owned by metadata_instance' do
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

    context 'attributes' do
      before { subject.entity_descriptor = create :entity_descriptor }
      context 'without attributes' do
        before { subject.attributes.clear }
        it { is_expected.not_to be_valid }
      end
      context 'with attributes' do
        it { is_expected.to be_valid }
      end
    end
  end

  describe '#destroy' do
    subject do
      create :mdattr_entity_attribute, :with_refeds_rs_entity_category
    end

    it 'is successfully destroyed' do
      expect { subject.destroy }.not_to raise_error
    end
  end
end
