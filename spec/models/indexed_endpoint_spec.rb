# frozen_string_literal: true

require 'rails_helper'

describe IndexedEndpoint do
  context 'extends an Endpoint' do
    it { is_expected.to validate_presence :is_default }
    it { is_expected.to validate_presence :index }
  end

  describe '#default?' do
    subject { endpoint.default? }

    context 'for a default endpoint' do
      let(:endpoint) { IndexedEndpoint.new(is_default: true) }
      it { is_expected.to be_truthy }
    end

    context 'for a non-default endpoint' do
      let(:endpoint) { IndexedEndpoint.new(is_default: false) }
      it { is_expected.to be_falsey }
    end
  end
end
