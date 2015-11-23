require 'rails_helper'

describe AttributeConsumingService do
  it_behaves_like 'a basic model'

  it { is_expected.to have_one_to_many :service_descriptions }
  it { is_expected.to validate_presence :index }
  it { is_expected.to validate_presence :default }

  let(:subject) { create :attribute_consuming_service }
  it 'has at least 1 service name' do
    expect(subject).to validate_presence :service_names
  end
  it 'has at least 1 requested attribute' do
    expect(subject).to validate_presence :requested_attributes
  end
  it 'is invalid when no requested attributes' do
    subject.requested_attributes.clear
    expect(subject).not_to be_valid
  end

  describe '#destroy' do
    subject do
      create :attribute_consuming_service
    end

    it 'is successfully destroyed' do
      expect { subject.destroy }.not_to raise_error
    end
  end
end
