# frozen_string_literal: true

require 'rails_helper'

describe AssertionIdRequestService do
  context 'Extends Endpoint' do
    it { is_expected.to have_many_to_one :idp_sso_descriptor }
    it { is_expected.to have_many_to_one :attribute_authority_descriptor }

    let(:subject) { create :assertion_id_request_service }
    context 'valid ownership' do
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
  end
end
