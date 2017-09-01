# frozen_string_literal: true

require 'rails_helper'

describe KeyDescriptor do
  it_behaves_like 'a basic model'

  context 'validations' do
    context 'instance validations' do
      let(:subject) { create :key_descriptor, :signing }
      it { is_expected.to validate_presence :key_info }
      it { is_expected.to validate_includes %i[encryption signing], :key_type }
    end
  end

  describe '#destroy' do
    subject do
      create :key_descriptor, :encryption
    end

    it 'is successfully destroyed' do
      expect { subject.destroy }.not_to raise_error
    end
  end
end
